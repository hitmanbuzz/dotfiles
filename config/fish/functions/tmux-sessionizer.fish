function tmux-sessionizer --description 'Create/attach a tmux session for a directory'
    # 1. Select directory
    set -l selected
    if test (count $argv) -eq 1
        set selected $argv[1]
    else
        set selected (
            find ~/ ~/Projects \
                -mindepth 1 \
                -maxdepth 3 \
                -type d 2>/dev/null |
            fzf --reverse
        )
    end

    # Nothing selected
    if test -z "$selected"
        return 0
    end

    # 2. Create session name from path
    set selected (realpath "$selected")

    set -l session_name
    if test "$selected" = "$HOME"
        set session_name home
    else
        set -l relative_path (string replace -- "$HOME/" "" "$selected")
        set session_name "$relative_path"
        set session_name (string replace -a '.' '_' "$session_name")
        set session_name (string replace -a ':' '_' "$session_name")
        set session_name (string replace -a '/' '-' "$session_name")
    end

    # 3. Create session if it doesn't exist
    if not tmux has-session -t "$session_name" 2>/dev/null
        tmux -u new-session \
            -ds "$session_name" \
            -c "$selected"
        or return 1
    end

    # 4. Attach or switch
    if test -z "$TMUX"
        tmux -u attach-session -t "$session_name"
    else
        tmux -u switch-client -t "$session_name"
    end
end
