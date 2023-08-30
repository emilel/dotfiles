#!/bin/python3

import subprocess

names = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

sessions = (
    subprocess.run(
        'tmux list-sessions -F "#{session_name}"',
        shell=True,
        stdout=subprocess.PIPE,
    )
    .stdout.strip()
    .decode()
    .split("\n")
)
name = next(name for name in names if name not in sessions)
print(name)
