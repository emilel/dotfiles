#!/usr/bin/env bash

tmux set -t "$session:$window" -p @label "edit"
tmux send-keys -t "$session:$window" 'nvim' C-l C-m
