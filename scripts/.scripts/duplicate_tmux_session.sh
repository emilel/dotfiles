#!/bin/zsh -f

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <session-name>"
    exit 1
fi

session_name=$1

swaymsg exec "foot tmux new-session -t $session_name"
