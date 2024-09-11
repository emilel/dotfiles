#!/bin/sh

grim - > /tmp/screen.png
convert /tmp/screen.png -scale 10% -scale 1000% -fill black -colorize 75% /tmp/screen.png
swaylock -i /tmp/screen.png
rm /tmp/screen.png
