set -e
i3-msg "focus output eDP-1"
CUR=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name')
i3-msg "workspace number 0"
i3-msg "focus output DP-1"
i3-msg "workspace number 4, move workspace to output DP-1"
i3-msg "workspace number 5, move workspace to output DP-1"
i3-msg "workspace number 6, move workspace to output DP-1"
i3-msg "workspace number 7, move workspace to output DP-1"
i3-msg "workspace number 8, move workspace to output DP-1"
i3-msg "workspace number 9, move workspace to output DP-1"
i3-msg "workspace $CUR"
