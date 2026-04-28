#!/usr/bin/env bash

id=$(tmux list-panes -s -F '#{pane_id} #{@label}' | awk -v L="$1" '$2==L{print $1}')
[ -n "$id" ] && echo "$id" || exit 1
