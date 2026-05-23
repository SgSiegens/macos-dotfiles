#!/usr/bin/env bash

# Adjust these to your actual paths
DOTFILES="$HOME/dotfiles"
SB_CONF="$HOME/.simplebarrc"
WAL_CACHE="$HOME/.cache/wal"
SB_WIDGET="$HOME/ubersicht/widgets/simple-bar"

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
ln -sf "$WAL_CACHE/pywal_theme.js" "$SB_WIDGET/lib/styles/themes/pywal_theme.js"
ln -sf "$WAL_CACHE/bordersrc" "$DOTFILES/.config/borders/bordersrc"
ln -sf "$WAL_CACHE/btopwal.theme" "$HOME/.config/btop/themes/btopwal.theme"

tmux source-file ~/.cache/wal/pywal.tmux

if pgrep -x "sketchybar" > /dev/null
then
    sketchybar --reload
fi

# # Simplebar needs some addtional handling
# if [ -f "$SB_WIDGET/lib/styles/pywal/pywal-gen.sh" ]; then
#     bash "$SB_WIDGET/lib/styles/pywal/pywal-gen.sh"
# fi
# ln -sf "$WAL_CACHE/.simplebarrc" "$HOME/.simplebarrc"
#
# # update simplebarrc
# # bash ~/scripts/update_simplebar.sh >> /tmp/pywal_update.log 2>&1
#
# osascript -e 'tell application id "tracesOf.Uebersicht" to refresh'

bash ~/.config/borders/bordersrc

# Update  all Kitty Terminals
for socket in /tmp/kitty*; do
    if [ -S "$socket" ]; then
        /Applications/kitty.app/Contents/MacOS/kitty @ --to "unix:$socket" set-colors -a "$WAL_CACHE/colors-kitty.conf"
    fi
done
