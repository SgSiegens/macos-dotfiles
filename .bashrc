# if [ -z "$BASH_VERSION" ] && command -v bash >/dev/null 2>&1; then
#   exec bash -l
# fi

export BASH_SILENCE_DEPRECATION_WARNING=1

export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"

export PATH="/opt/local/bin:/opt/local/sbin:${HOME}/.local/bin:${PATH}"
export MANPATH="/opt/local/share/man:$MANPATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export COLORTERM=truecolor
[ -f ~/.cache/wal/sequences ] && (cat ~/.cache/wal/sequences &)

# Setup fzf
# for a helpful tutorial check out https://thevaluable.dev/fzf-shell-integration/
# ---------
if [[ ! "$PATH" == */opt/homebrew/bin* ]]; then
    PATH="${PATH:+${PATH}:}/opt/homebrew/bin"
fi


[ -f ~/.config/shell/aliases ] && source ~/.config/shell/aliases
[ -f ~/.config/shell/functions ] && source ~/.config/shell/functions
[ -f ~/.config/shell/key-bindings.bash ] && source ~/.config/shell/key-bindings.bash
[ -f ~/.config/shell/completion.bash ] && source ~/.config/shell/completion.bash


# alias ls='ls -GFh'
# alias ll='ls -alGFh'

[[ $TMUX ]]

PS1='\u@\h:\w$ '
