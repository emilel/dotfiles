#!/bin/zsh -f

workspace_number=$($HOME/.config/scripts/get_workspace_number.sh)
read "input?rename:   "
swaymsg rename workspace to "$workspace_number:$input"
exit
