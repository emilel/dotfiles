#!/bin/zsh -f

set -e

session=$(tmux list-sessions -F "#{session_name}" | grep -v - | tofi)
if [[ -z "$session" ]]; then
    return 1
fi
swaymsg exec "foot tmux new-session -t $session"
