#!/bin/zsh

if [ $# -eq 1 ]; then
    name=$1
else
    read "name?rename: "
fi

number=$(swaymsg --pretty --type get_workspaces | grep -Po "Workspace \K(\d*)(?=.* \(focused\))")
if [ -z "$name" ]; then
  full_name="$number"
else
  full_name="$number:$name"
fi
swaymsg rename workspace to "$full_name"
