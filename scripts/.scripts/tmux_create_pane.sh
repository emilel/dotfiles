#!/usr/bin/env bash

directory=$1
session=$2
window=$3

tmux split-window -d -h -c $directory -t "$session:$window" -P -F '#{pane_id}'
