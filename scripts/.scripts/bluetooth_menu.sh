#!/bin/sh
# fzf-pick a known bluetooth device and toggle its connection. Saner than the
# tray managers for the common "connect my headphones" case.
set -eu

# Mark currently-connected devices with ✓. Lines become "<mark>\t<mac>\t<name>";
# fzf shows the mark and name (fields 1,3..) and hides the mac, which we pull
# back out of field 2 for the selection.
connected=$(bluetoothctl devices Connected 2>/dev/null | awk '{print $2}')
sel=$(bluetoothctl devices | while read -r _ mac name; do
    if printf '%s\n' "$connected" | grep -qxF "$mac"; then m="✓"; else m=" "; fi
    printf '%s\t%s\t%s\n' "$m" "$mac" "$name"
done |
    fzf --delimiter='\t' --with-nth=1,3.. --prompt 'bt> ' \
        --header 'Bluetooth — ✓ connected. Enter toggles connect/disconnect, Esc cancels') || exit 1
mac=$(printf '%s' "$sel" | cut -f2)
[ -n "$mac" ] || exit 1

if bluetoothctl info "$mac" | grep -q 'Connected: yes'; then
    exec bluetoothctl disconnect "$mac"
else
    exec bluetoothctl connect "$mac"
fi
