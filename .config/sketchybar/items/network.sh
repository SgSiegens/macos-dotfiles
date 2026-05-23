#!/bin/bash

sketchybar --add item network right \
  --set network \
    update_freq=10 \
    label.width=8 \
    script="$PLUGIN_DIR/network.sh" \
    click_script="$PLUGIN_DIR/wificlick.sh" \
  --subscribe network wifi_change system_woke \
  --subscribe network mouse.entered  \
  --subscribe network mouse.exited  \
  --subscribe network mouse.exited.global
