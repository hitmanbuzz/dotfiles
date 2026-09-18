source /usr/share/cachyos-fish-config/cachyos-config.fish

# ALIASES
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias hx='helix'
alias btop='btop --force-utf'
alias tmux='tmux -u'
alias ll="ls -l"
alias pkg-install="~/dotfiles/scripts/packages.sh"
alias config-sym="~/dotfiles/scripts/stowing.sh"
alias vid-comp="~/.config/custom_scripts/video.sh"
alias ytd="~/.config/custom_scripts/ytd-h264.sh"

# ENVIRONMENT VARIABLES
# cargo
if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
else
    fish_add_path "$HOME/.cargo/bin"
end

# go paths
if type -q go
    fish_add_path (go env GOPATH)/bin
end

# local bin
fish_add_path "$HOME/.local/bin"

# TMUX SESSIONIZER
function tmux_sessionizer_bind
    commandline -r tmux-sessionizer
    commandline -f execute
end

# Ctrl-F → sessionizer when outside tmux
bind \cf tmux_sessionizer_bind

set -g fish_greeting
starship init fish | source
