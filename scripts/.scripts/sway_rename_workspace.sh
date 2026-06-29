#!/bin/sh
# Rename the focused sway workspace, preserving its leading number.
set -eu

if [ "$#" -ge 1 ]; then
    name=$1
else
    printf 'rename: ' >&2
    read -r name
fi

number=$(swaymsg --pretty --type get_workspaces |
    grep -Po 'Workspace \K(\d*)(?=.* \(focused\))')

if [ -z "$name" ]; then
    full_name="$number"
else
    full_name="$number:$name"
fi

exec swaymsg rename workspace to "$full_name"
