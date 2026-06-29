#!/bin/sh
# Create window $2 in session $1 unless a window of that name already exists.
set -eu

session=$1
window=$2

if ! tmux list-windows -t "$session" -F '#{window_name}' 2>/dev/null | grep -Fxq "$window"; then
    tmux new-window -d -t "$session" -n "$window"
fi
