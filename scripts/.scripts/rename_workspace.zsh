#!/bin/zsh

if [ $# -eq 1 ]; then
    name=$1
else
    read "name?rename: "
fi

number=$(swaymsg --pretty --type get_workspaces | grep -Po "Workspace \K(\d*)(?=.* \(focused\))")
swaymsg rename workspace to "$number:$name"
