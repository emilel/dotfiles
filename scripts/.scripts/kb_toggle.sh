#!/bin/sh
# Flip the Kinesis Advantage2 between us (firmware layout) and se, for when
# swedish needs writing. Sway gives it "us,se"; this cycles the index. Waybar's
# custom/kb shows + clicks this -- `status` prints nothing (module hidden)
# unless the board is plugged in.
set -eu

kb=10730:258:Kinesis_Advantage2_Keyboard

case "${1:-toggle}" in
    status)
        idx=$(swaymsg -t get_inputs | jq -r --arg id "$kb" \
            'first(.[] | select(.identifier == $id and .type == "keyboard") | .xkb_active_layout_index) // empty')
        case $idx in
            '') ;;
            1) echo '{"text":"SE","class":"se"}' ;;
            *) echo '{"text":"US","class":"us"}' ;;
        esac
        ;;
    *) swaymsg input "$kb" xkb_switch_layout next >/dev/null ;;
esac
