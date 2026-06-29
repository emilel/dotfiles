#!/bin/sh
# fzf-pick a known bluetooth device and toggle its connection. Saner than the
# tray managers for the common "connect my headphones" case.
set -eu

sel=$(bluetoothctl devices | fzf --with-nth=2..) || exit 1
mac=$(printf '%s' "$sel" | awk '{print $2}')
[ -n "$mac" ] || exit 1

if bluetoothctl info "$mac" | grep -q 'Connected: yes'; then
    exec bluetoothctl disconnect "$mac"
else
    exec bluetoothctl connect "$mac"
fi
