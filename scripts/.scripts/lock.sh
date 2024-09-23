#!/bin/sh

OUTPUT_IMAGE="/tmp/screen_lock.png"

grim "$OUTPUT_IMAGE"
convert "$OUTPUT_IMAGE" -scale 10% -scale 1000% -fill black -colorize 75% "$OUTPUT_IMAGE"
swaylock -i "$OUTPUT_IMAGE"
