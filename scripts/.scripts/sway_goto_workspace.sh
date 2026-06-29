#!/bin/sh
# Switch to the first sway workspace whose name contains $1.
set -eu

name=$1
workspace=$(swaymsg -t get_workspaces |
    jq -r --arg n "$name" '.[] | select(.name | contains($n)) | .name' |
    head -n1)

if [ -z "$workspace" ]; then
    echo "no workspace matching '$name'" >&2
    exit 1
fi

exec swaymsg workspace "$workspace"
