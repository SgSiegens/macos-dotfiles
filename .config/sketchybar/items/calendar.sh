#!/bin/bash

CALENDAR_WIDTH=250

# ============================================================
# Calendar Popup
# ============================================================

sketchybar --add item calendar center \
           --set calendar \
                 update_freq=10 \
                 script="$PLUGIN_DIR/calendar.sh" \
                 popup.align=center \
                 popup.height=2 \
                 popup.background.border_width=2 \
                 popup.background.corner_radius=3 \
                 popup.background.color="$background" \
                 popup.horizontal=off \
           --subscribe calendar mouse.clicked \
           --subscribe calendar mouse.entered \
           --subscribe calendar mouse.exited \
           --subscribe calendar mouse.exited.global


# ============================================================
# Top Spacer
# Gives the clock some breathing room from the top border.
# ============================================================

sketchybar --add item calendar.top_spacer popup.calendar \
           --set calendar.top_spacer \
                 width=$CALENDAR_WIDTH \
                 icon.drawing=off \
                 label.drawing=off


# ============================================================
# Time
# ============================================================

sketchybar --add item calendar.details popup.calendar \
           --set calendar.details \
                 update_freq=1 \
                 width=$CALENDAR_WIDTH \
                 icon.drawing=off \
                 label.width=$CALENDAR_WIDTH \
                 label.align=center \
                 label.padding_left=0 \
                 label.padding_right=0 \
                 label.y_offset=0 \
                 label.color="$ITEM_COLOR" \
                 label.font="JetBrains Mono:Bold:30.0" \
                 script="sketchybar --set \$NAME label=\"\$(date '+%H:%M:%S')\""


# ============================================================
# Date
# ============================================================

sketchybar --add item calendar.date popup.calendar \
           --set calendar.date \
                 update_freq=60 \
                 width=$CALENDAR_WIDTH \
                 icon.drawing=off \
                 label.width=$CALENDAR_WIDTH \
                 label.align=center \
                 label.padding_left=0 \
                 label.padding_right=0 \
                 label.y_offset=0 \
                 label.color=0xffffffff \
                 label.font="VT323:Regular:16.0" \
                 script="sketchybar --set \$NAME label=\"\$(date '+%d.%m.%Y, %A')\""


# ============================================================
# Calendar Spacer
# Creates extra space between the date and calendar.
# ============================================================

sketchybar --add item calendar.calendar_spacer popup.calendar \
           --set calendar.calendar_spacer \
                 width=$CALENDAR_WIDTH \
                 icon.drawing=off \
                 label.drawing=off


# ============================================================
# Calendar Grid
# ============================================================

CAL_PADDING=0

COUNTER=0

cal | tail -n +2 | while IFS= read -r LINE; do

    sketchybar --add item "calendar.cal_$COUNTER" popup.calendar \
               --set "calendar.cal_$COUNTER" \
                     width=$CALENDAR_WIDTH \
                     icon.drawing=off \
                     label.width=$CALENDAR_WIDTH \
                     label.align=left \
                     label.padding_left=50 \
                     label.padding_right=$CAL_PADDING \
                     label.color="${ITEM_COLOR:-0xffffffff}" \
                     label.font="Menlo:Regular:12.0" \
                     label="$LINE"

    COUNTER=$((COUNTER + 1))

done

