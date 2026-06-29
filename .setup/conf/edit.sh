#!/bin/sh
# shellcheck disable=SC2154  # session/window exported by tmux_apply_template.sh
tmux set -t "$session:$window" -p @label "edit"
tmux send-keys -t "$session:$window" 'nvim' C-l C-m
