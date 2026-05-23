#!/bin/bash

export color0=0xff000000   # dark background
export color1=0xff003547   # slightly lighter dark
export color2=0xff005566   # mid-dark teal
export color3=0xff007a8a   # mid teal
export color4=0xff2cf9ed   # bright accent (cyan-teal)
export color5=0xff00d4cb   # secondary accent
export color6=0xff00b8b0   # muted accent
export color7=0xffc0dfe0   # light foreground / dimmed white
export color8=0xff0a3040   # bright-black (dark gray)
export color9=0xff1a5060   # bright variant of color1
export color10=0xff4dfaf0  # bright variant of color2
export color11=0xff80fcf7  # bright variant of color3
export color12=0xff50d8ff  # bright blue-ish
export color13=0xffb3fefb  # pale teal
export color14=0xffd9fefd  # near-white teal
export color15=0xffffffff  # white

# -- Special pywal variables --
export background=0xff001f30
export foreground=0xff2cf9ed
export cursor=0xff2cf9ed
export alpha="0"           # transparency (0 = fully opaque)
export wallpaper=""        # filled by pywal at runtime

# -- Named sketchybar aliases (map palette → semantic roles) --

export WHITE=$color1

export BAR_COLOR=$background   # darkest  → bar fill

export TEXT_COLOR=$foreground

export ITEM_BG_COLOR=$color1   # mid-dark → item background
export ITEM_COLOR=$foreground

export ACCENT_COLOR=$color4    # bright   → highlights / icons

# color for items 
export HIGHLIGHT_BORDER_COLOR=$color1
export DEFAULT_BORDER_COLOR=$BAR_COLOR
