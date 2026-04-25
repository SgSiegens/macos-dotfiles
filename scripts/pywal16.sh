#!/usr/bin/env bash

# symlink all templates so that the colors get adopted
ln -sf ~/.cache/wal/flameshot.ini ~/dotfiles/.config/flameshot/flameshot.ini

# update the simple-bar colors via their provided script
"$HOME/ubersicht/widgets/simple-bar/lib/styles/pywal/pywal-gen.sh"

# update all kitty terminals
for socket in /tmp/kitty*; do
    # Check if the file is actually a socket to prevent errors
    if [ -S "$socket" ]; then
        /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:$socket" set-colors -a ~/.cache/wal/colors-kitty.conf
    fi
done