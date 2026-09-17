#!/bin/sh
# Pick a command from $PATH in the fullscreen prompt and run it. swaymsg exec
# rather than a plain & so the app is sway's child, not this script's, and
# outlives the keybinding that started it.
set -eu

cmd=$("$HOME/.scripts/sway_prompt.sh" --run) || exit 0
[ -n "$cmd" ] || exit 0

exec swaymsg exec -- "$cmd"
