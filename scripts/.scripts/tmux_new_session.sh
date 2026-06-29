#!/bin/sh
# Attach to (or create) the first free session from a fixed pool of names.
set -eu

for name in one two three four five six seven eight nine ten; do
    if ! tmux has-session -t "$name" 2>/dev/null; then
        exec tmux new-session -s "$name"
    fi
done

echo "all sessions already exist" >&2
exit 1
