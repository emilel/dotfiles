#!/bin/sh
# fzf-pick a session and attach to it in the current terminal.
set -eu

session=$(tmux list-sessions -F '#{session_name}' | fzf --select-1) || exit 1
[ -n "$session" ] || exit 1
exec tmux attach-session -t "$session"
