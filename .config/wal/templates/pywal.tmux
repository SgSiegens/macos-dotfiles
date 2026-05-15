# Pywal tmux template
## Base status bar styling (transparent background, default foreground)
set -g status-style bg=default,fg="{foreground}"

## -------------------------------------------------------------------
## Window Status
## -------------------------------------------------------------------
setw -g window-status-format '#[fg={color8},bg=default] #I #W #[default]'
setw -g window-status-current-format '#[fg={color4},bg=default,bold] #I #W #[default]'
setw -g window-status-activity-style fg="{color4}",bg=default,none

## -------------------------------------------------------------------
## Panes
## -------------------------------------------------------------------
set -g pane-border-style bg=default,fg="{color8}"
set -g pane-active-border-style bg=default,fg="{color7}"

## -------------------------------------------------------------------
## Clock & Messages
## -------------------------------------------------------------------
set -g clock-mode-colour "{color4}"
set -g clock-mode-style 24

# Message bar — color1 (accent) bg so it's always visible against any theme
set -g message-style bg="{color5}",fg="{color15}",bold
set -g message-command-style bg="{color5}",fg="{color15}",bold

# Copy mode highlight
set -g mode-style bg="{color4}",fg="{color0}"

## -------------------------------------------------------------------
## Status Right
## -------------------------------------------------------------------
set -g status-right-length 100
set -g status-right '#[fg={color4},bg=default] %H:%M #[fg={color8}]| #[fg={color7}]%y.%m.%d '
