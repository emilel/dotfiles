#!/bin/sh
# External monitor on the left, laptop on the right, at the resolutions you
# actually use -- a 4K external at its native mode is unreadable. Adapts to
# whichever external is plugged (DP-1, HDMI-A-1, or none). sway runs this on
# every reload (exec_always) and $mod+Shift+m re-runs it after a hotplug.
set -eu

ext_res=2560x1440 # what the external runs at, if it supports that mode
lap_res=1920x1080 # what the laptop panel runs at

outs=$(swaymsg -t get_outputs)
pick() { printf '%s' "$outs" | jq -r "$1 // empty"; }
has_mode() { printf '%s' "$outs" | jq -e --arg n "$1" --arg r "$2" 'any(.[]|select(.name==$n).modes[]; "\(.width)x\(.height)"==$r)' >/dev/null; }
native_w() { pick "(.[]|select(.name==\"$1\")|.modes|max_by(.width*.height)|.width)"; }

laptop=$(pick 'first(.[]|select(.name|test("^eDP"))|.name)')
ext=$(pick 'first(.[]|select(.active and (.name|test("^eDP")|not))|.name)')
[ -n "$laptop" ] || laptop=$ext # desktop with no internal panel

# Put output $1 at resolution $2 (or its native mode if $2 isn't supported), x=$3.
place() {
    if has_mode "$1" "$2"; then
        swaymsg output "$1" mode "$2" pos "$3" 0 >/dev/null
    else
        swaymsg output "$1" pos "$3" 0 >/dev/null
    fi
}

if [ -n "$ext" ]; then
    place "$ext" "$ext_res" 0
    if has_mode "$ext" "$ext_res"; then ew=${ext_res%x*}; else ew=$(native_w "$ext"); fi
    place "$laptop" "$lap_res" "${ew:-2560}"
    left=$ext
else
    place "$laptop" "$lap_res" 0
    left=$laptop
fi
right=$laptop

for ws in 1 2 3 7 8 9; do swaymsg workspace "$ws" output "$left"; done
for ws in 4 5 6 10; do swaymsg workspace "$ws" output "$right"; done

wp() { [ -e "$2" ] && swaymsg output "$1" bg "$2" fill; }
wp "$left" "$HOME/wallpapers/wallpaper_1.jpg" || true
wp "$right" "$HOME/wallpapers/wallpaper_2.jpg" || true
