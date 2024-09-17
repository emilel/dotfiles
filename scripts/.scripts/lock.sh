#!/bin/sh

TMP_DIR=$(mktemp -d)

for output in $(swaymsg -t get_outputs | jq -r '.[].name'); do
    grim -o "$output" "$TMP_DIR/screen_$output.png"
    convert "$TMP_DIR/screen_$output.png" -scale 10% -scale 1000% -fill black -colorize 75% "$TMP_DIR/screen_$output.png"
done

swaylock $(for output in $(swaymsg -t get_outputs | jq -r '.[].name'); do echo -i "$output:$TMP_DIR/screen_$output.png"; done)
