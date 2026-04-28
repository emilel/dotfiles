#!/usr/bin/env bash

pane_id="$("$HOME/.scripts/tmux_create_pane.sh" $directory $session $window)"
tmux set -t "$session:$window.$pane_id" -p @label "shell"
