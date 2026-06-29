#!/bin/sh
# External on the left, laptop on the right, each at its NATIVE resolution (so
# text stays crisp) but per-output scaled to a comfortable size. The external is
# scaled so it "feels" $ext_logical px wide whatever its real panel is: a 4K runs
# native + scale 1.5 (sharp), a 1440p runs native + scale 1.0 -- instead of
# blurring a 4K down to a non-native mode. Adapts to whichever external is
# plugged; exec_always + $mod+Shift+m re-run it.
set -eu

ext_logical=2560 # external is scaled to feel this wide (scale derived from native res)
lap_scale=1      # laptop scale (eDP 1080p)

outs=$(swaymsg -t get_outputs)
pick() { printf '%s' "$outs" | jq -r "$1 // empty"; }
native() { pick "(.[]|select(.name==\"$1\")|.modes|max_by(.width*.height)|\"\(.width)x\(.height)\")"; }
native_w() { pick "(.[]|select(.name==\"$1\")|.modes|max_by(.width*.height)|.width)"; }

laptop=$(pick 'first(.[]|select(.name|test("^eDP"))|.name)')
ext=$(pick 'first(.[]|select(.active and (.name|test("^eDP")|not))|.name)')
[ -n "$laptop" ] || laptop=$ext # desktop with no internal panel

place() { # name mode scale x
    if [ -n "$2" ]; then
        swaymsg output "$1" mode "$2" scale "$3" pos "$4" 0 >/dev/null
    else
        swaymsg output "$1" scale "$3" pos "$4" 0 >/dev/null
    fi
}

if [ -n "$ext" ]; then
    ew=$(native_w "$ext")
    [ -n "$ew" ] || ew=$ext_logical
    scale=$(LC_ALL=C awk -v w="$ew" -v t="$ext_logical" 'BEGIN{s=w/t; if(s<1)s=1; printf "%g", s}')
    lap_x=$(LC_ALL=C awk -v w="$ew" -v s="$scale" 'BEGIN{printf "%d", w/s}')
    place "$ext" "$(native "$ext")" "$scale" 0
    place "$laptop" "$(native "$laptop")" "$lap_scale" "$lap_x"
    left=$ext
else
    place "$laptop" "$(native "$laptop")" "$lap_scale" 0
    left=$laptop
fi
right=$laptop

for ws in 1 2 3 7 8 9; do swaymsg workspace "$ws" output "$left"; done
for ws in 4 5 6 10; do swaymsg workspace "$ws" output "$right"; done

wp() { [ -e "$2" ] && swaymsg output "$1" bg "$2" fill; }
wp "$left" "$HOME/wallpapers/wallpaper_1.jpg" || true
wp "$right" "$HOME/wallpapers/wallpaper_2.jpg" || true
