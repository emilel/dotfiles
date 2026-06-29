#!/bin/sh
# Print the id of the pane whose @label is $1 (exit 1 if there is none).
set -eu

id=$(tmux list-panes -s -F '#{pane_id} #{@label}' | awk -v label="$1" '$2 == label {print $1}')
[ -n "$id" ] || exit 1
printf '%s\n' "$id"
