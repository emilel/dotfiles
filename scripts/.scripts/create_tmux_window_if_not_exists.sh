#!/bin/bash

session="$1"
window="$2"

if ! tmux list-windows -t "$session" -F "#{window_name}" 2>/dev/null | grep -Fxq "$window"; then
    tmux new-window -d -t "$session" -n "$window"
fi
