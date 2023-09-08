#!/bin/zsh -f

swaymsg --pretty --type get_workspaces | grep -Po "Workspace \K(\d*)(?=.* \(focused\))"
