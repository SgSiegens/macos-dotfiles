#!/bin/bash


# Source Colors
if [ -f "$HOME/.cache/wal/sketchybar_colors.sh" ]; then
    source "$HOME/.cache/wal/sketchybar_colors.sh"
else
    source "$CONFIG_DIR/colors.sh"
fi
# Source Layout Variables
source "$CONFIG_DIR/variables.sh"

# ── Helpers ───────────────────────────────────────────────────────────────────

volume_up() {
  osascript -e 'set volume output volume ((output volume of (get volume settings)) + 5)'
}

volume_down() {
  osascript -e 'set volume output volume ((output volume of (get volume settings)) - 5)'
}

VOLFILE=/tmp/last_volume
toggle_mute() {
  MUTED=$(osascript -e 'output muted of (get volume settings)')
  if [[ "$MUTED" == "true" ]]; then          # ← was $muted
    LAST_VOL=$(cat "$VOLFILE" 2>/dev/null || echo 50)
    osascript -e 'set volume without output muted'
    osascript -e "set volume output volume $LAST_VOL"
  else
    osascript -e 'output volume of (get volume settings)' > "$VOLFILE"
    osascript -e 'set volume with output muted'
    osascript -e "set volume output volume 0"
  fi
}

# ── State update ──────────────────────────────────────────────────────────────
# $INFO is only a clean integer when SENDER=volume_change.
# Every other event (scroll, click, …) also sets $INFO to its own payload,
# so we must guard — otherwise scroll JSON ends up as the label.

volume_update() {
  local VOLUME
  if [[ "$SENDER" == "volume_change" ]]; then
    VOLUME="$INFO"
  else
    VOLUME=$(osascript -e 'output volume of (get volume settings)')
  fi
  local MUTED
  MUTED=$(osascript -e 'output muted of (get volume settings)')

  case "$MUTED:$VOLUME" in
    true:*)               ICON="󰝟" ;;
    *:100|*:[6-9][0-9])   ICON="󰕾" ;;
    *:[3-5][0-9])         ICON="󰖀" ;;
    *:[1-2][0-9]|*:[1-9]) ICON="󰕿" ;;
    *)                    ICON="󰝟" ;;
  esac

  sketchybar --set volume icon="$ICON" label="$VOLUME%"
}

# ── Event dispatch ────────────────────────────────────────────────────────────

case "$SENDER" in
"volume_change")
  volume_update
  ;;
"mouse.scrolled")
  if [[ $SCROLL_DELTA -gt 0 ]]; then
    volume_up
  else
    volume_down
  fi
  volume_update
  ;;
"mouse.entered")
  sketchybar --set volume \
    background.border_color=$HIGHLIGHT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
"mouse.exited" | "mouse.exited.global")
    sketchybar --set $NAME icon.highlight=off label.highlight=off background.border_color=$DEFAULT_BORDER_COLOR background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
"mouse.clicked")
  toggle_mute
  volume_update
 sketchybar --set $NAME icon.highlight_color=$color4 label.highlight_color=$color4
    sketchybar --set $NAME icon.highlight_color=$color7 label.highlight_color=$color7
    sketchybar --set $NAME icon.highlight=off label.highlight=off popup.drawing=off
  ;;
esac
