#!/bin/zsh -f

set -e

session=$(tmux list-sessions -F "#{session_name}" | tofi)
if [[ -z "$session" ]]; then
    return 1
fi
swaymsg exec "foot tmux attach -t $session"
