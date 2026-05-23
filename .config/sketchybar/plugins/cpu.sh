#!/bin/bash

# Source Colors
if [ -f "$HOME/.cache/wal/sketchybar_colors.sh" ]; then
    source "$HOME/.cache/wal/sketchybar_colors.sh"
else
    source "$CONFIG_DIR/colors.sh"
fi

# Source Layout Variables
source "$CONFIG_DIR/variables.sh"

case "$SENDER" in
"mouse.clicked")
  # get display dimensions
  IFS='x' read -ra arr <<< "$(
    xdpyinfo |
    grep dimensions |
    sed -r 's/^[^0-9]*([0-9]+x[0-9]+).*$/\1/'
  )"

  w_per="0.75"
  h_per="0.75"
  width=$( bc <<< "scale=0; (${arr[0]} * $w_per) / 1")
  height=$( bc <<< "scale=0; (${arr[1]} * $h_per) / 1")
  x_pos=$( bc <<< "scale=0; (${arr[0]} - $width) / 2")
  y_pos=$( bc <<< "scale=0; (${arr[1]} - $height) / 2")

  launchctl asuser "$(id -u)" /Applications/kitty.app/Contents/MacOS/kitty \
    --title pop-up \
    --start-as=normal \
    --override remember_window_size=no \
    --override initial_window_width="$width" \
    --override initial_window_height="$height" \
    --position "$x_pos x $y_pos" \
    -e btop
  exit 0
  ;;
"mouse.entered")
  sketchybar --set "$NAME" \
    background.border_color="$HIGHLIGHT_BORDER_COLOR" \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set "$NAME" \
    icon.highlight=off \
    label.highlight=off \
    background.border_color="$DEFAULT_BORDER_COLOR" \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
esac

CORE_COUNT=$(sysctl -n machdep.cpu.thread_count)
CPU_INFO=$(ps -eo pcpu,user)
CPU_SYS=$(echo "$CPU_INFO" | grep -v "$(whoami)" | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")
CPU_USER=$(echo "$CPU_INFO" | grep "$(whoami)" | sed "s/[^ 0-9\.]//g" | awk "{sum+=\$1} END {print sum/(100.0 * $CORE_COUNT)}")

CPU_PERCENT="$(echo "$CPU_SYS $CPU_USER" | awk '{printf "%.0f\n", ($1 + $2)*100}')"

sketchybar --set "$NAME" label="$CPU_PERCENT%"
