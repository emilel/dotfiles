#!/bin/sh

battery=$(upower -e enumerate | head -n1 | xargs -I{} upower -i {} | grep -oP 'percentage:\s*\K[0-9]+' | xargs -I{} echo BAT {} %)
date=$(date +"%Y-%m-%d %H:%M:%S")

echo "$battery | $date"
