#!/bin/python

import subprocess

sessions = (
    subprocess.run(
        "tmux list-sessions -F '#{session_name}'",
        shell=True,
        stdout=subprocess.PIPE,
    )
    .stdout.strip()
    .decode()
).split("\n")
unique_sessions = sorted(set(session.split("_")[0] for session in sessions if len(session)))

if len(unique_sessions):
    print(", ".join(unique_sessions) + " ")
else:
    print("- ")
