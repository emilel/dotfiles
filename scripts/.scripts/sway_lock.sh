#!/bin/sh
# Lock the screen, showing a pixelated screenshot of each output (sway).
set -eu

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

swaymsg -t get_outputs | jq -r '.[].name' | while IFS= read -r output; do
    grim -o "$output" "$tmp/screen_$output.png"
    convert "$tmp/screen_$output.png" -scale 10% -scale 1000% \
        -fill black -colorize 75% "$tmp/screen_$output.png"
done

# Build one '-i <output>:<image>' pair per screenshot.
set --
for img in "$tmp"/screen_*.png; do
    [ -e "$img" ] || continue
    output=${img##*/screen_}
    output=${output%.png}
    set -- "$@" -i "$output:$img"
done

swaylock --color 242424 "$@"
