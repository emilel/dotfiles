#!/usr/bin/env bash

directory=$1
session="$(basename $directory)"

shopt -s nullglob

# if there is no such session, create it
if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$directory" -n scrap

    # read template files in .tmux/window/pane.sh
    for file in "$directory"/.setup/*/*.sh; do
        [ -f "$file" ] || continue

        window=$(basename "$(dirname "$file")")
        pane_name="${file##*/}"; pane_name="${pane_name%.sh}"

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

if [ -n "$TMUX" ]; then
    tmux switch-client -t "$session"
else
    tmux attach -t "$session"
fi
