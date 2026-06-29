#!/bin/sh
# External monitor on the left at its native resolution, laptop on the right;
# workspaces pinned. Adapts to whichever external is plugged (DP-1, HDMI-A-1, or
# none on the laptop alone). sway runs `exec_always` on every reload, and
# $mod+Shift+m re-runs it after a hotplug.
set -eu

outs=$(swaymsg -t get_outputs)
pick() { printf '%s' "$outs" | jq -r "$1 // empty"; }

laptop=$(pick 'first(.[]|select(.name|test("^eDP"))|.name)')
ext=$(pick 'first(.[]|select(.active and (.name|test("^eDP")|not))|.name)')
[ -n "$laptop" ] || laptop=$ext # desktop with no internal panel

# Highest-resolution mode of an output ("WxH", empty if unknown) and its width.
native() { pick "(.[]|select(.name==\"$1\")|.modes|max_by(.width*.height)|\"\(.width)x\(.height)\")"; }
mode_w() { printf '%s' "$outs" | jq -r --arg n "$1" '(.[]|select(.name==$n)|.modes|max_by(.width*.height)|.width) // 0'; }

place() { # name x
    m=$(native "$1")
    if [ -n "$m" ]; then
        swaymsg output "$1" mode "$m" pos "$2" 0 >/dev/null
    else
        swaymsg output "$1" pos "$2" 0 >/dev/null
    fi
}

if [ -n "$ext" ]; then
    place "$ext" 0
    place "$laptop" "$(mode_w "$ext")"
    left=$ext
else
    place "$laptop" 0
    left=$laptop
fi
right=$laptop

for ws in 1 2 3 7 8 9; do swaymsg workspace "$ws" output "$left"; done
for ws in 4 5 6 10; do swaymsg workspace "$ws" output "$right"; done

wp() { [ -e "$2" ] && swaymsg output "$1" bg "$2" fill; }
wp "$left" "$HOME/wallpapers/wallpaper_1.jpg" || true
wp "$right" "$HOME/wallpapers/wallpaper_2.jpg" || true
