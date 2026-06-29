#!/bin/sh
# shellcheck disable=SC2154  # directory/session/window exported by tmux_apply_template.sh
pane_id="$("$HOME/.scripts/tmux_create_pane.sh" "$directory" "$session" "$window")"
tmux set -t "$session:$window.$pane_id" -p @label "shell"
