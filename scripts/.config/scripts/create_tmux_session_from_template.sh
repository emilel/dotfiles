#!/bin/zsh -f

set -e

dir="$HOME/.config/scripts/tmux_templates"
script=$(ls $dir | fzf --no-info --no-scrollbar --no-color --pointer=' ' --layout=reverse)
swaymsg exec "foot $dir/$script"
