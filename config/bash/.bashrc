#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
alias ..="cd .."
eval "$(starship init bash)"
alias ll="ls -l"
alias pkg-install="~/dotfiles/scripts/packages.sh"
alias config-sym="~/dotfiles/scripts/stowing.sh"
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

# Bind Ctrl+T to run the sessionizer script
bind '"\C-t":"tmux-sessionizer\n"'

[[ $PS1 &&
  ! ${BASH_COMPLETION_VERSINFO:-} &&
  -f /usr/share/bash-completion/bash_completion ]] &&
    . /usr/share/bash-completion/bash_completion

export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
