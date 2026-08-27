#!/bin/sh
# Waybar's custom/network: the link that traffic actually leaves by, not just
# "some link is up" -- with eth and wifi both connected, waybar's own module
# picks either one, so print whichever default route has the lowest metric.
# Red when NetworkManager says the connection doesn't reach the internet
# (captive portal, limited, or nothing at all).
set -eu

RED='#d75f5f'
proc=${NET_PROC:-/proc/net} # overridable for the tests

# Default routes live in /proc/net/route as destination 00000000; field 7 is the
# metric, field 1 the interface. Lowest metric wins -- that's the one in use.
dev=$(awk '$2 == "00000000" { print $7, $1 }' "$proc/route" | sort -n | awk 'NR == 1 { print $2 }')

if [ -z "$dev" ]; then
    text=OFFL
elif grep -q "^ *$dev:" "$proc/wireless" 2>/dev/null; then # in /proc/net/wireless -> wifi
    ssid=$(nmcli -t -f ACTIVE,SSID dev wifi list --rescan no 2>/dev/null |
        awk -F: '$1 == "yes" { s = $2; gsub(/&/, "\\&amp;", s); gsub(/</, "\\&lt;", s); print s; exit }')
    dbm=$(awk -v d="$dev:" '$1 == d { print int($4) }' "$proc/wireless")
    text="${ssid:-$dev} ($dbm dBm)"
else
    text=ETH
fi

case $(nmcli -t -f CONNECTIVITY general 2>/dev/null) in
    full) printf '%s\n' "$text" ;;
    *) printf '<span color="%s">%s</span>\n' "$RED" "$text" ;; # up, but no internet
esac
