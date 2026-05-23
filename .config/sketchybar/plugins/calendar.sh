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
"mouse.entered")
  sketchybar --set $NAME \
    background.border_color=$HIGHLIGHT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS \
    label.padding_left=0 \
    label.padding_right=9
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set $NAME \
    icon.highlight=off \
    label.highlight=off \
    background.border_color=$DEFAULT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
"mouse.clicked")
  sketchybar --set $NAME popup.drawing=toggle
  # open -a Calendar
  ;;
*)
  sketchybar --set $NAME label="$(date +'%H:%M')"
  ;;
esac
