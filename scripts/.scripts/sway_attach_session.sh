#!/bin/sh
# fzf-pick a tmux session and open it in a new foot window (sway).
set -eu

session=$(tmux list-sessions -F '#{session_name}' | fzf) || exit 1
[ -n "$session" ] || exit 1
exec swaymsg exec "foot tmux attach -t $session"
