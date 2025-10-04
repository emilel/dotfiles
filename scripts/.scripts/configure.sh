#!/bin/sh

session=conf
if tmux has-session -t "$session" 2>/dev/null; then
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "$session"
    else
        tmux attach -t "$session"
    fi
    return
fi

tmux new-session -ds "$session" -c ~/dotfiles
tmux send-keys -t "$session" 'nvim' C-l C-m

if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
else
    tmux attach -t "$session"
fi
