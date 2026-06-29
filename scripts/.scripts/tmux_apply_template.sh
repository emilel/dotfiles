#!/bin/sh
# Create a tmux session named after $1's basename, building its windows and panes
# from template scripts at <dir>/.setup/<window>/<pane>.sh, then switch/attach.
#
# Each pane script is run with $session, $window and $directory exported and is
# expected to print the new pane id (see tmux_create_pane.sh).
set -eu

directory=$1
session=$(basename "$directory")

if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$directory" -n scrap

    for file in "$directory"/.setup/*/*.sh; do
        [ -f "$file" ] || continue

        window=$(basename "$(dirname "$file")")
        pane_name=${file##*/}
        pane_name=${pane_name%.sh}

        if ! tmux list-windows -t "$session" -F '#W' | grep -Fxq "$window"; then
            tmux new-window -d -t "$session" -n "$window" -c "$directory"
        fi

        new_pane_id=$(session="$session" window="$window" directory="$directory" "$file")

        if [ -n "$new_pane_id" ]; then
            tmux set -t "$session:$window.$new_pane_id" -p @label "$pane_name"
        fi
    done

    tmux kill-window -t "$session:scrap"
fi

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$session"
else
    tmux attach -t "$session"
fi
