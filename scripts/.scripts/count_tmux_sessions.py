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

n_sessions = len(set(session for session in sessions if len(session)))
n_groups = len(set(session.split("_")[0] for session in sessions if len(session)))

if n_sessions != n_groups:
    print(f"{n_groups}+{n_sessions - n_groups}")
else:
    print(f"{n_groups}")
