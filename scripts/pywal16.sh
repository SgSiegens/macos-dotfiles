#!/usr/bin/env bash

# Adjust these to your actual paths
# DOTFILES defaults to ~/dotfiles but can be overridden
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
WAL_CACHE="$HOME/.cache/wal"

# --- race condition guard ---
PIDFILE="/tmp/pywal16.pid"
if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
    kill "$(cat "$PIDFILE")" 2>/dev/null
    sleep 0.1   # small grace period for it to die cleanly
fi
echo $$ > "$PIDFILE"
trap 'rm -f "$PIDFILE"' EXIT

# Sync  internal pywal files
ln -sf "$WAL_CACHE/flameshot.ini" "$DOTFILES/.config/flameshot/flameshot.ini"
ln -sf "$WAL_CACHE/bordersrc" "$DOTFILES/.config/borders/bordersrc"
ln -sf "$WAL_CACHE/btopwal.theme" "$HOME/.config/btop/themes/btopwal.theme"

tmux source-file ~/.cache/wal/pywal.tmux 2>/dev/null || true

if pgrep -x "sketchybar" > /dev/null
then
    sketchybar --reload
fi

bash ~/.config/borders/bordersrc

# Update  all Kitty Terminals
for socket in /tmp/kitty*; do
    if [ -S "$socket" ]; then
        /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:$socket" set-colors -a "$WAL_CACHE/colors-kitty.conf"
    fi
done
