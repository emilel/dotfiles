#!/bin/zsh -f

if [[ -n $1 ]]; then
    name=$1
else
    name=$(cat ~/.config/sway/workspace_names | tofi)
    if [[ -z "$name" ]]; then
        return 1
    fi
fi

workspace_number=$($HOME/.config/scripts/get_workspace_number.sh)
swaymsg rename workspace to "$workspace_number:$name"
exit
