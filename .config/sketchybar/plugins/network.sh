#!/bin/bash

# Source Colors
if [ -f "$HOME/.cache/wal/sketchybar_colors.sh" ]; then
    source "$HOME/.cache/wal/sketchybar_colors.sh"
else
    source "$CONFIG_DIR/colors.sh"
fi

# Source Layout Variables
source "$CONFIG_DIR/variables.sh"

# ── Mouse events ──────────────────────────────────────────────────────────────
case "$SENDER" in
"mouse.entered")
  sketchybar --set $NAME \
    background.border_color=$HIGHLIGHT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  exit 0
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set $NAME \
    icon.highlight=off \
    background.border_color=$DEFAULT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  exit 0
  ;;
"mouse.clicked")
  open "x-apple.systempreferences:com.apple.wifi-settings-extension"
  exit 0
  ;;
esac

# ── macOS version ─────────────────────────────────────────────────────────────
OS_MAJOR=$(sw_vers -productVersion | cut -d. -f1)
OS_MINOR=$(sw_vers -productVersion | cut -d. -f2)
OS_MINOR=${OS_MINOR:-0}

# ── 1. Wi-Fi interface ────────────────────────────────────────────────────────
WIFI_IF=$(networksetup -listallhardwareports \
  | awk '/Hardware Port: Wi-Fi/{getline; print $2}')

if [ -z "$WIFI_IF" ]; then
  sketchybar --set "$NAME" icon="󰤭 " icon.color="$ITEM_COLOR" label.drawing=off
  exit 0
fi

# ── 2. Power check ────────────────────────────────────────────────────────────
POWER=$(networksetup -getairportpower "$WIFI_IF" | awk '{print $4}')
if [ "$POWER" = "Off" ]; then
  sketchybar --set "$NAME" icon="󰤭 " icon.color="$ITEM_COLOR" label.drawing=off
  exit 0
fi

# ── 3. Connection check (version-aware) ───────────────────────────────────────
# macOS 15+: networksetup -getairportnetwork is removed — check for a live IP instead
# macOS 13/14: networksetup still works reliably
CONNECTED=false

if [ "$OS_MAJOR" -ge 15 ]; then
  IP=$(ifconfig "$WIFI_IF" 2>/dev/null | awk '/inet /{print $2; exit}')
  [ -n "$IP" ] && CONNECTED=true
else
  SSID_INFO=$(networksetup -getairportnetwork "$WIFI_IF" 2>/dev/null)
  [[ "$SSID_INFO" != *"You are not associated"* ]] && CONNECTED=true
fi

if [ "$CONNECTED" = false ]; then
  sketchybar --set "$NAME" icon="󰤯 " icon.color="$ITEM_COLOR" label.drawing=off
  exit 0
fi

# ── 4. RSSI retrieval (version-aware) ─────────────────────────────────────────
# < 14.4  → airport -I          (fast, direct)
# ≥ 14.4  → airport removed; system_profiler SPAirPortDataType is the only
#            unprivileged source that still exposes "Signal / Noise" on 14.4+
#            and on macOS 15 (wdutil redacts all Wi-Fi metadata without a
#            Developer-ID-signed + Location Services-approved binary)
RSSI=""

if [ "$OS_MAJOR" -lt 14 ] || { [ "$OS_MAJOR" -eq 14 ] && [ "$OS_MINOR" -lt 4 ]; }; then
  # macOS < 14.4 — airport is available
  AIRPORT="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
  if [ -x "$AIRPORT" ]; then
    RSSI=$("$AIRPORT" -I 2>/dev/null | awk '/agrCtlRSSI/{print $2}')
  fi
fi

# macOS ≥ 14.4 (or airport unavailable) — system_profiler fallback
# Parses: "Signal / Noise: -55 dBm / -95 dBm" → takes first negative number
if [ -z "$RSSI" ]; then
  RSSI=$(system_profiler SPAirPortDataType 2>/dev/null \
    | grep "Signal / Noise" \
    | grep -Eo '\-[0-9]+' \
    | head -1)
fi

# Last resort default (fair signal, avoids division errors downstream)
[ -z "$RSSI" ] && RSSI=-70

# ── 5. RSSI → quality % ──────────────────────────────────────────────────────
# Standard formula: quality = 2 × (RSSI + 100), clamped 0–100
# -50 dBm → 100% | -65 dBm → 70% | -80 dBm → 40% | -90 dBm → 20%
QUALITY=$(echo "$RSSI" | awk '{
  q = 2 * ($1 + 100)
  if (q < 0)   q = 0
  if (q > 100) q = 100
  printf "%.0f", q
}')

# ── 6. Icon + color ───────────────────────────────────────────────────────────
if   [ "$QUALITY" -ge 80 ]; then ICON="󰤨 "; COLOR="$ITEM_COLOR"  # blue   ≥ -60 dBm
elif [ "$QUALITY" -ge 60 ]; then ICON="󰤥 "; COLOR="$ITEM_COLOR"  # green  -60 to -70
elif [ "$QUALITY" -ge 40 ]; then ICON="󰤢 "; COLOR="$ITEM_COLOR"  # orange -70 to -80
else                              ICON="󰤟 "; COLOR="$ITEM_COLOR"  # red    < -80 dBm
fi

# ── 7. Apply — icon only, no label ───────────────────────────────────────────
sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$COLOR" \
  label.drawing=off
