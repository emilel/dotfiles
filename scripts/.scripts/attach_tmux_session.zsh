#!/bin/zsh

session=$(tmux list-sessions -F "#{session_name}" | fzf)
if [[ -z "$session" ]]; then
    return 1
fi

swaymsg exec "foot tmux attach -t $session"
