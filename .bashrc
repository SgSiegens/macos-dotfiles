export BASH_SILENCE_DEPRECATION_WARNING=1

export CLICOLOR=1
export LSCOLORS="Gxfxcxdxbxegedabagacad"

export PATH="/opt/local/bin:/opt/local/sbin:${HOME}/.local/bin:${PATH}"
export MANPATH="/opt/local/share/man:$MANPATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

(cat ~/.cache/wal/sequences &)

alias ls='ls -GFh'
alias ll='ls -alGFh'

PS1='\u@\h:\w$ '
