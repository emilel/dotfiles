#!/bin/sh
# fzf-pick a wifi network and connect (nmcli prompts for the password if it's a
# new one). Right-click the waybar widget for full nmtui.
#
# Rescan is best-effort: NetworkManager rate-limits scans, so --rescan yes errors
# (empty list) if one ran recently. Trigger a rescan, ignore failure, then list
# the cached results so the picker is never empty.
set -eu

nmcli dev wifi rescan 2>/dev/null || true
# ACTIVE,SSID is terse "yes:SSID" / "no:SSID"; ACTIVE never has a colon, so the
# SSID is everything past the first one. Mark the connected network with ✓.
ssid=$(nmcli -t -f ACTIVE,SSID dev wifi list --rescan no |
    awk -F: '{ s = substr($0, index($0, ":") + 1) }
        s != "" && !seen[s]++ { printf "%s\t%s\n", ($1 == "yes" ? "✓" : " "), s }' |
    fzf --delimiter='\t' --prompt 'wifi> ' \
        --header 'Nearby Wi-Fi — ✓ connected. Enter connects, Esc cancels' |
    cut -f2-) || exit 1
[ -n "$ssid" ] || exit 1
exec nmcli dev wifi connect "$ssid"
