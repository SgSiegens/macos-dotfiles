#!/usr/bin/env bash

# slightly scuffed wallpaper picker menu for use with pywal - uses nsxiv if installed, otherwise uses dmenu

FOLDER=~/.config/wallpapers # wallpaper folder
SCRIPT=~/scripts/pywal16.sh # script to run after wal for refreshing programs, etc.


menu () {
		if command -v nsxiv >/dev/null; then 
				CHOICE=$(nsxiv -otb $FOLDER/*)
		else 
				CHOICE=$(echo -e "Random\n$(command ls -v $FOLDER)" | dmenu -c -l 15 -i -p "Wallpaper: ")
		fi

case $CHOICE in
		Random) wal -i "$FOLDER" -o $SCRIPT --cols16;; # dmenu random option
		*.*) wal -i "$CHOICE" -o $SCRIPT --cols16;;
		*) exit 0 ;;
esac
}

# If given arguments:
# First argument will be used by pywal as wallpaper/dir path
# Second will be used as theme (use wal --theme to view built-in themes)

case "$#" in
		0) menu ;;
		1) wal -i "$1" -o $SCRIPT --cols16;;
		2) wal -i "$1" --theme $2 -o $SCRIPT --cols16;;
		*) exit 0 ;;
esac
