#!/bin/bash

sketchybar --add item calendar center \
           --set calendar update_freq=10 \
                          script="$PLUGIN_DIR/calendar.sh" \
                          popup.align=center \
                          popup.background.border_width=2   \
                          popup.background.corner_radius=3  \
                          popup.background.color="$background" \
                          popup.horizontal=off\
           --subscribe calendar mouse.clicked \
           --subscribe calendar mouse.entered  \
           --subscribe calendar mouse.exited  \
           --subscribe calendar mouse.exited.global


sketchybar --add item calendar.details popup.calendar \
           --set calendar.details update_freq=1 \
                                  width=160\
                                  label.y_offset=2\
                                  label.padding_left=30 \
                                  label.padding_right=40 \
                                  icon.drawing=off \
                                  label.align=center \
                                  label.color="$ITEM_COLOR" \
                                  label.font="JetBrains Mono:Bold:30.0" \
                                  script="sketchybar --set \$NAME label=\"\$(date '+%H:%M:%S')\""

# 2. Date Item (White Text underneath Time)
    sketchybar --add item calendar.date popup.calendar \
               --set calendar.date update_freq=3600 \
                                   icon.drawing=off \
                                   label.color=0xffffffff \
                                   label.font="VT323:Regular:16.0" \
                                   label.padding_left=30 \
                                   label.padding_right=30 \
                                   script="sketchybar --set \$NAME label=\"\$(date '+%d.%m.%Y, %A')\""


# 3. Calendar Grid (Inside the Popup)
COUNTER=0
cal | while IFS= read -r line; do
  sketchybar --add item calendar.cal_$COUNTER popup.calendar \
             --set calendar.cal_$COUNTER icon.drawing=off \
                                      label.font="Menlo:Regular:12.0" \
                                      label.padding_left=15 \
                                      label.padding_right=15 \
                                      label.align=center \
                                      label="$line"
  COUNTER=$((COUNTER+1))
done
