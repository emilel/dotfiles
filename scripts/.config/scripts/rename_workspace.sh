#!/bin/zsh -f

if [[ -n $1 ]]; then
    name=$1
else
    read "name?rename:   "
fi

workspace_number=$($HOME/.config/scripts/get_workspace_number.sh)
swaymsg rename workspace to "$workspace_number:$name"
exit
