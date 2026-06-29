#!/bin/sh
# Open another foot window attached to a new session grouped with $1 (sway).
set -eu

if [ -z "${1:-}" ]; then
    echo "usage: ${0##*/} <session-name>" >&2
    exit 1
fi

exec swaymsg exec "foot tmux new-session -t $1"
