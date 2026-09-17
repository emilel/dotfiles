#!/bin/sh
# Rename the focused sway workspace, preserving its leading number.
#
#   sway_rename_workspace.sh web    name given outright (the `rnw` alias)
#   sway_rename_workspace.sh        read from the terminal
#   sway_rename_workspace.sh -p     ask in the fullscreen prompt ($mod+m)
#
# -p is explicit rather than sniffed: sway inherits its own stdin to execed
# bindings, so a tty check would silently pick `read` and hang with nothing
# on screen.
set -eu

if [ "${1:-}" = -p ]; then
    name=$("$HOME/.scripts/sway_prompt.sh" --prompt-text 'rename: ' </dev/null) || exit 0
elif [ "$#" -ge 1 ]; then
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
