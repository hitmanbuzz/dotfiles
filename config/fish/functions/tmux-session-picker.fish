function tmux-session-picker --description 'Fuzzy-pick a tmux session to jump to'
    set -l tmpfile (mktemp)

    tmux-session-list | fzf \
        --reverse \
        --header 'Jump to Session  |  Ctrl-X: Kill' \
        --preview 'tmux capture-pane -pt {}' \
        --bind 'ctrl-x:execute(tmux kill-session -t {} 2>/dev/null)+reload(tmux-session-list)' >$tmpfile

    set -l selected (cat $tmpfile)
    rm -f $tmpfile

    if test -z "$selected"
        return 0
    end

    if test -z "$TMUX"
        tmux -u attach-session -t "$selected"
    else
        tmux -u switch-client -t "$selected"
    end
end
