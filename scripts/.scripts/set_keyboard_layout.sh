#!/bin/sh

layout="$1"
swaymsg -s /run/user/1000/sway-ipc.1000.46608.sock input "*" xkb_layout $layout
