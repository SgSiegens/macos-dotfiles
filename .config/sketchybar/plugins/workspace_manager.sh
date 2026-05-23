#!/usr/bin/env bash
#
# workspace_manager.sh
#
# Subscribed to the aerospace_workspace_change event.
# On every workspace switch this script:
#   1. Adds bar items for workspaces that appeared since last run
#   2. Removes bar items for workspaces that no longer exist
#   3. Reorders items to match AeroSpace's workspace order
#   4. Updates the visual state (active / has-windows / empty) for every item
#
# Because this is the single source of truth for workspace appearance,
# individual space.* items no longer need their own `script` or subscription.

# Source theme variables (same as sketchybarrc does)
if [ -f "$HOME/.cache/wal/sketchybar_colors.sh" ]; then
    source "$HOME/.cache/wal/sketchybar_colors.sh"
else
    source "$CONFIG_DIR/colors.sh"
fi
source "$CONFIG_DIR/variables.sh"

FOCUSED=${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}
ALL_WORKSPACES=$(aerospace list-workspaces --all)

# Items currently in the bar that start with "space."
CURRENT_ITEMS=$(sketchybar --query bar | jq -r '.items[] | select(startswith("space."))')

# ── 1. Add workspaces that don't have a bar item yet ─────────────────────────

for WS in $ALL_WORKSPACES; do
    ITEM="space.$WS"
    if ! echo "$CURRENT_ITEMS" | grep -qx "$ITEM"; then
        sketchybar --add item "$ITEM" left \
                   --set "$ITEM" \
                       label="$WS" \
                       label.align=center \
                       label.width=dynamic \
                       background.drawing=off \
                       click_script="aerospace workspace $WS"
    fi
done

# ── 2. Remove items whose workspace no longer exists ─────────────────────────

for ITEM in $CURRENT_ITEMS; do
    WS="${ITEM#space.}"
    if ! echo "$ALL_WORKSPACES" | grep -qx "$WS"; then
        sketchybar --remove "$ITEM"
    fi
done

# ── 3. Reorder bar items to match AeroSpace's workspace order ─────────────────

ORDERED=()
for WS in $ALL_WORKSPACES; do
    ORDERED+=("space.$WS")
done
sketchybar --reorder "${ORDERED[@]}"

# ── 4. Update visual state for every workspace item ───────────────────────────

for WS in $ALL_WORKSPACES; do
    ITEM="space.$WS"
    WINDOW_COUNT=$(aerospace list-windows --workspace "$WS" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$WS" = "$FOCUSED" ]; then
        # Force a fixed width for the active item to ensure the underline centers correctly
        # Adjust 'width=30' to match what looks best for your font size
        sketchybar --set "$ITEM" \
            label.font="$LABEL_FONT"                                      \
            label.color="$color5"                                         \
            label.highlight_color="$ACCENT_COLOR"                         \
            label.padding_left=0                                          \
            label.padding_right=0                                         \
            label.drawing="$LABEL_DRAWING"                                \
            background.drawing=on                                         \
            background.color="$ACCENT_COLOR"                              \
            background.height=2                                           \
            background.corner_radius=0                                    \
            background.y_offset=-15                                       \
            width=28                                                      \
            padding_left=5                                                \
            padding_right=5


    elif [ "$WINDOW_COUNT" -gt 0 ]; then
        # Inactive but has windows — muted foreground, no underline
        # Restore normal label and item paddings
        sketchybar --set "$ITEM" \
            label.font="$LABEL_FONT"                                      \
            label.color="$color7"                                         \
            label.highlight_color="$ACCENT_COLOR"                         \
            label.padding_left="$LABEL_PADDING_LEFT"                      \
            label.padding_right="$LABEL_PADDING_RIGHT"                    \
            label.drawing="$LABEL_DRAWING"                                \
            background.drawing=off                                        \
            padding_left="$ITEM_PADDING_LEFT"                             \
            padding_right="$ITEM_PADDING_RIGHT"

    else
        # Empty workspace — dark/dimmed, no underline
        # Restore normal label and item paddings
        sketchybar --set "$ITEM" \
            label.font="$LABEL_FONT"                                      \
            label.color="$color3"                                         \
            label.highlight_color="$ACCENT_COLOR"                         \
            label.padding_left="$LABEL_PADDING_LEFT"                      \
            label.padding_right="$LABEL_PADDING_RIGHT"                    \
            label.drawing="$LABEL_DRAWING"                                \
            background.drawing=off                                        \
            padding_left="$ITEM_PADDING_LEFT"                             \
            padding_right="$ITEM_PADDING_RIGHT"
    fi
done
