#!/bin/sh
# Split a new pane in $session:$window rooted at $directory; print its pane id.
set -eu

directory=$1
session=$2
window=$3

exec tmux split-window -d -h -c "$directory" -t "$session:$window" -P -F '#{pane_id}'
