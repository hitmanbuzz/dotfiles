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
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"

# Bind Ctrl+T to run the sessionizer script
bind '"\C-t":"tmux-sessionizer\n"'

export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.local/bin:$PATH"
