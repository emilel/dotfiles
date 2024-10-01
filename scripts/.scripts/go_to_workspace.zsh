#!/bin/zsh

# Argument: workspace name (e.g., "web", "slack")
workspace_name=$1

# Find the workspace that matches the argument
workspace=$(swaymsg -t get_workspaces | jq -r '.[] | select(.name | contains("'$workspace_name'")) | .name')

# Check if the workspace was found
if [ -n "$workspace" ]; then
    # Switch to the found workspace
    swaymsg workspace "$workspace"
else
    echo "Workspace matching '$workspace_name' not found."
fi
