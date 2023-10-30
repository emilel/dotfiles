#!/bin/zsh -f

set -e

dir="$HOME/.config/scripts/tmux_templates"
script=$(ls $dir | tofi)
if [[ -z "$script" ]]; then
    return 1
fi
swaymsg exec "foot $dir/$script"
