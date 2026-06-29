#!/bin/sh
# fzf-pick a tmux template from ~/.tmux_templates and run it.
set -eu

template=$(
    for f in "$HOME"/.tmux_templates/*; do
        [ -e "$f" ] && basename "$f"
    done | fzf
) || exit 1
[ -n "$template" ] || exit 1
exec "$HOME/.tmux_templates/$template"
