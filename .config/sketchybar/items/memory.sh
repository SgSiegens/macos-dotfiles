#!/bin/bash

sketchybar --add item ram right \
           --set ram  update_freq=2 \
                      icon=  \
                      label.width=110 \
                      script="$PLUGIN_DIR/memory.sh" \
           --subscribe ram mouse.clicked \
           --subscribe ram mouse.entered  \
           --subscribe ram mouse.exited  \
           --subscribe ram mouse.exited.global  
