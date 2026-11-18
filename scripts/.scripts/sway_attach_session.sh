#!/bin/sh
# Pick a tmux session in the fullscreen prompt ($mod+t) and open it in a new
# foot window. require-match: a typo shouldn't try to attach to nothing.
set -eu

session=$(tmux list-sessions -F '#{session_name}' |
    "$HOME/.scripts/sway_prompt.sh" --prompt-text 'attach: ' --require-match true) || exit 0
[ -n "$session" ] || exit 0
exec swaymsg exec "foot tmux attach -t $session"
