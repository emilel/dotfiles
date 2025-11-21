#!/bin/sh

session=conf
target_dir="$HOME/dotfiles"

current_session=""
current_pane=""
if [ -n "$TMUX" ]; then
    current_session=$(tmux display-message -p '#S' 2>/dev/null || true)
    current_pane=$(tmux display-message -p '#{pane_id}' 2>/dev/null || true)
fi

if [ "$current_session" = "$session" ] && [ -n "$current_pane" ]; then
    tmux send-keys -t "$current_pane" "cd \"$target_dir\" && nvim" C-m
    exit 0
fi

if tmux has-session -t "$session" 2>/dev/null; then
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session"
    else
        tmux attach -t "$session"
    fi
    exit 0
fi

tmux new-session -ds "$session" -c "$target_dir"
tmux send-keys -t "$session" 'nvim' C-l C-m

if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
else
    tmux attach -t "$session"
fi
