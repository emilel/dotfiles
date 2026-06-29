#!/bin/sh
# External on the left, laptop on the right, per-output scaled to a comfortable
# size ($ext_logical px wide whatever the panel is). The external mode depends on
# the display_toggle.sh preference: "smooth" (default) picks the largest >=50Hz
# mode so the cursor stays fluid (a 4K does 30Hz over HDMI -> laggy); "crisp"
# picks the native max-res mode (sharper, lower refresh). Adapts to whichever
# external is plugged; exec_always + $mod+Shift+m re-run it.
set -eu

ext_logical=2560 # external is scaled to feel this wide (scale derived from chosen mode width)
lap_scale=1      # laptop scale (eDP 1080p)
min_hz=50000     # "smooth": lowest acceptable refresh, in mHz

pref_file=${XDG_RUNTIME_DIR:-/tmp}/sway_ext_mode
pref=$(cat "$pref_file" 2>/dev/null) || pref=smooth
[ "$pref" = crisp ] || pref=smooth

outs=$(swaymsg -t get_outputs)
pick() { printf '%s' "$outs" | jq -r "$1 // empty"; }
# Best mode for output $1 under preference $2 ("smooth"|"crisp") -> "WxH".
# smooth keeps only >=min_hz modes (refresh absent -> assume 60Hz); both then
# take the largest area, tie-broken by highest refresh.
mode() {
    printf '%s' "$outs" | jq -r --arg n "$1" --arg p "$2" --argjson hz "$min_hz" '
        [.[] | select(.name==$n).modes[]] as $all
        | (if $p=="crisp" then $all
           else [$all[] | select((.refresh // 60000) >= $hz)] end) as $f
        | (if ($f|length) > 0 then $f else $all end)
        | max_by(.width*.height*1000000 + (.refresh // 60000))
        | "\(.width)x\(.height)"'
}

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
    m=$(mode "$ext" "$pref")
    ew=${m%x*}
    [ -n "$ew" ] || ew=$ext_logical
    scale=$(LC_ALL=C awk -v w="$ew" -v t="$ext_logical" 'BEGIN{s=w/t; if(s<1)s=1; printf "%g", s}')
    lap_x=$(LC_ALL=C awk -v w="$ew" -v s="$scale" 'BEGIN{printf "%d", w/s}')
    place "$ext" "$m" "$scale" 0
    place "$laptop" "$(mode "$laptop" smooth)" "$lap_scale" "$lap_x"
    left=$ext
else
    place "$laptop" "$(mode "$laptop" smooth)" "$lap_scale" 0
    left=$laptop
fi
right=$laptop

for ws in 1 2 3 7 8 9; do swaymsg workspace "$ws" output "$left"; done
for ws in 4 5 6 10; do swaymsg workspace "$ws" output "$right"; done

wp() { [ -e "$2" ] && swaymsg output "$1" bg "$2" fill; }
wp "$left" "$HOME/wallpapers/wallpaper_1.jpg" || true
wp "$right" "$HOME/wallpapers/wallpaper_2.jpg" || true
