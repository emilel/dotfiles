#!/bin/sh
# fzf-pick a wifi network from a fresh scan and connect (nmcli prompts for the
# password if it's a new one). Right-click the waybar widget for full nmtui.
set -eu

ssid=$(nmcli -t -f SSID dev wifi list --rescan yes | awk 'NF && !seen[$0]++' | fzf) || exit 1
[ -n "$ssid" ] || exit 1
exec nmcli dev wifi connect "$ssid"
