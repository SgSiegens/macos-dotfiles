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

  open -na /Applications/kitty.app --args \
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
  sketchybar --set $NAME \
    background.border_color=$HIGHLIGHT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
"mouse.exited" | "mouse.exited.global")
  sketchybar --set $NAME \
    icon.highlight=off \
    label.highlight=off \
    background.border_color=$DEFAULT_BORDER_COLOR \
    background.border_width=$ITEM_BG_CORNER_RADIUS
  ;;
esac

total_bytes=$(sysctl -n hw.memsize)
total_gb=$(echo "$total_bytes" | awk '{printf "%.0f", $1/1073741824}')

free_gb=$(vm_stat | awk -v page_size=4096 '
  /page size of/       { page_size = $8 }
  /Pages free/         { free = $3 }
  /Pages inactive/     { inactive = $3 }
  /Pages speculative/  { spec = $4 }
  END {
    gsub(/\./, "", free)
    gsub(/\./, "", inactive)
    gsub(/\./, "", spec)
    available = (free + inactive + spec) * page_size
    printf "%.1f", available / 1073741824
  }
')

used_gb=$(echo "$total_gb $free_gb" | awk '{printf "%.1f", $1 - $2}')
used_pct=$(echo "$used_gb $total_gb" | awk '{printf "%.0f", ($1/$2)*100}')

sketchybar --set "$NAME" label="${used_gb}GB (${used_pct}%)"
