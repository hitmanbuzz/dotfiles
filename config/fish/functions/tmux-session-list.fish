function tmux-session-list --description 'List unattached tmux sessions'
    tmux list-sessions \
        -F '#{?session_attached,,#{session_name}}' 2>/dev/null |
        string match -rv '^$'
    or true
end
