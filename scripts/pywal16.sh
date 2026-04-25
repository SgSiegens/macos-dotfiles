#!/usr/bin/env bash

ln -sf ~/.cache/wal/flameshot.ini ~/dotfiles/.config/flameshot/flameshot.ini

for socket in /tmp/kitty*; do
    # Check if the file is actually a socket (-S) to prevent errors
    if [ -S "$socket" ]; then
        # Push the new colors to this specific Kitty instance
        /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:$socket" set-colors -a ~/.cache/wal/colors-kitty.conf
    fi
done

/Users/thm/dotfiles/.config/ubersicht/widgets/simple-bar/lib/styles/pywal/pywal-gen.sh