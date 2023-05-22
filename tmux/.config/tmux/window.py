#!/bin/python

import sys
import subprocess

active_flag, index, name, marked_flag, bell_flag, last_flag, zoomed_flag, mode_flag, pid = sys.argv[1:]
active = active_flag == '1'
marked = marked_flag == "1"
bell = bell_flag == "1"
zoomed = zoomed_flag == "1"
copy_mode = mode_flag == "1"
last = last_flag == "1"


child = (
    subprocess.run(
        f"pgrep -P {pid}",
        shell=True,
        stdout=subprocess.PIPE,
    )
    .stdout.strip()
    .decode()
)

cpu = (
    subprocess.run(
        f"ps -p {child} -o %cpu=",
        shell=True,
        stdout=subprocess.PIPE,
    )
    .stdout.strip()
    .decode()
)

if copy_mode:
    left, right = ("[", "]")
elif zoomed:
    left, right = ("(", ")")
else:
    left, right = (" ", " ")

ACTIVE_FG = "colour223,bold"
ACTIVE_AND_MARKED_BG = "colour67"
ACTIVE_BG = "colour66"

BELL_BG="colour167"

INACTIVE_FG = "colour223"
INACTIVE_BG = "colour239"
MARKED_BG = "colour243"

if active:
    bg = ACTIVE_AND_MARKED_BG if marked else ACTIVE_BG
    fg = ACTIVE_FG
else:
    if bell:
        bg = BELL_BG
    elif marked:
        bg = MARKED_BG
    else:
        bg = INACTIVE_BG
    fg = INACTIVE_FG

current_style = f"#[bg={bg},fg={fg}]"
current_string = (
    f"{current_style} {'-' if last else ' '}{index}{left}{name}{'.' if child else ''}{right} "
)

print(current_string)
