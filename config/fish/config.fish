# Better man page formatting (need `bat`)
set -gx MANROFFOPT -c
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"

bind \cd ''

# ALIASES
alias update='yay -Syu'
alias ..='cd ..'
alias ls='eza -al --color=always --group-directories-first --icons=always'
alias la='eza -a --color=always --group-directories-first --icons=always'
alias ll='eza -l --color=always --group-directories-first --icons=always'
alias lt='eza -@ --color=always --group-directories-first --icons=always'
alias l.="eza -a | grep -e '^\.'"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias jctl="journalctl -p 3 -xb"
alias grep='grep --color=auto'
alias dir='dir --color=auto'
alias hx='helix'
alias btop='btop --force-utf'
alias hw='hwinfo --short'
alias tmux='tmux -u'

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

function tmux_picker_bind
    tmux-session-picker
    commandline -f repaint
end

# Override Fish's default Ctrl-S (pager-toggle-search)
bind \cs tmux_picker_bind

# Ctrl-F → sessionizer when outside tmux
bind \cf tmux_sessionizer_bind

set -g fish_greeting
starship init fish | source
