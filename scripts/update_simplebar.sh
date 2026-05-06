#!/usr/bin/env bash

SB_CONF="$HOME/.simplebarrc"
WAL_CACHE="$HOME/.cache/wal"
SB_WIDGET="$HOME/ubersicht/widgets/simple-bar"

# Simplebar needs some addtional handling
if [ -f "$SB_WIDGET/lib/styles/pywal/pywal-gen.sh" ]; then
    bash "$SB_WIDGET/lib/styles/pywal/pywal-gen.sh"
fi

# Inject colors into .simplebarrc via jq
if [ -f "$WAL_CACHE/mycolors.sh" ]; then
    # load generated color palette
    source "$WAL_CACHE/mycolors.sh"

    NEW_STYLES=":root {
      --main: $background;
      --main-alt: $color1;
      --minor: $color1;
      --accent: $color12;
      --red: $color3;
      --green: $color12;
      --yellow: $cursor;
      --orange: $color3;
      --blue: $color4;
      --magenta: $color2;
      --cyan: $color1;
      --black: $color0;
      --white: $color15;
      --foreground: $foreground;
      --background: $background;
      --transparent-dark: rgba(0, 0, 0, 0.05);
      --font: \"JetBrains Mono\", Monaco, Menlo, monospace;
      --font-size: 11.5px;
      --bar-height: 34px;
      --bar-radius: 6px;
      --bar-border: 0px solid transparent;
      --bar-inner-margin: 3px;
      --item-max-width: 160px;
      --item-radius: 5px;
      --item-inner-margin: 3px 7px;
      --item-outer-margin: 0 0 0 5px;
      --hover-ring: 0 0 0 2px rgba(255, 255, 255, 0.75);
      --focus-ring: 0 0 0 2px rgb(255, 255, 255);
      --light-shadow: 0 5px 10px rgba(0, 0, 0, 0.4);
      --foreground-shadow: 0 0 0 1px var(--foreground);
      --transition-easing: cubic-bezier(0.4, 0, 0.2, 1);
      --click-effect: rgba(255, 255, 255, 0.3);
    }"

    if command -v jq >/dev/null 2>&1; then
        jq --arg styles "$NEW_STYLES" '.customStyles.styles = $styles' "$SB_CONF" > "$SB_CONF.tmp" && mv "$SB_CONF.tmp" "$SB_CONF"
    else
        echo "Error: jq not found."
    fi
fi
