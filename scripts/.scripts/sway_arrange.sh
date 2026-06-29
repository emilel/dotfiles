#!/bin/sh
# External monitor (whatever it's named today) on the left, laptop on the right,
# workspaces pinned -- so home, Stockholm and laptop-only all just work without a
# per-location script. Runs on sway start and on $mod+Shift+m.
set -eu

outs=$(swaymsg -t get_outputs)
laptop=$(printf '%s' "$outs" | jq -r 'first(.[]|select(.name|test("^eDP"))|.name) // empty')
ext=$(printf '%s' "$outs" | jq -r 'first(.[]|select(.active and (.name|test("^eDP")|not))|.name) // empty')
[ -n "$laptop" ] || laptop=$ext # desktop with no internal panel

if [ -n "$ext" ]; then
    w=$(printf '%s' "$outs" | jq -r --arg n "$ext" 'first(.[]|select(.name==$n)|.current_mode.width // .rect.width) // 1920')
    swaymsg output "$ext" pos 0 0
    swaymsg output "$laptop" pos "$w" 0
    left=$ext
else
    left=$laptop
fi
right=$laptop

for ws in 1 2 3 7 8 9; do swaymsg workspace "$ws" output "$left"; done
for ws in 4 5 6 10; do swaymsg workspace "$ws" output "$right"; done

wp() { [ -e "$2" ] && swaymsg output "$1" bg "$2" fill; }
wp "$left" "$HOME/wallpapers/wallpaper_1.jpg" || true
wp "$right" "$HOME/wallpapers/wallpaper_2.jpg" || true
