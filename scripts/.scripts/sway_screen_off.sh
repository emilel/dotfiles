#!/bin/sh
# Blank the screen by signalling swayidle.
sleep 0.5 && exec killall -USR1 swayidle
