# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# User configuration
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
alias btop='btop --force-utf'
alias tmux='tmux -u'
alias ..="cd .."
alias ll="ls -l"
alias pkg-install="~/dotfiles/scripts/packages.sh"
alias config-sym="~/dotfiles/scripts/stowing.sh"
alias vid-comp="~/.config/custom_scripts/video.sh"
alias ytd="~/.config/custom_scripts/ytd-h264.sh"

# ENVIRONMENT VARIABLES (Compatible)
. "$HOME/.cargo/env"
export PATH=$PATH:$(go env GOPATH)/bin
export PATH="$HOME/.local/bin:$PATH"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

bindkey -s '^t' 'tmux-sessionizer^M'

autoload -Uz compinit
compinit

plugins=(git)

source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# bun completions
[ -s "/home/hitmanbuzz/.bun/_bun" ] && source "/home/hitmanbuzz/.bun/_bun"
