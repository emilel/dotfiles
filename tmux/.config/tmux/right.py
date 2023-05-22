#!/bin/python

import sys
import subprocess

pane_path, session_name, user, host = sys.argv[1:]
pane_dir = pane_path.split("/")[-1]

FOLDER_FG = "colour223"
FOLDER_BG = "colour132"

HOST_FG = "colour237,bold"
HOST_BG = "colour142"

TMUX_FG = "colour237,bold"
TMUX_BG = "colour166"

dir_style = f"#[bg={FOLDER_BG},fg={FOLDER_FG}]"
dir_string = f"{dir_style}  {pane_dir}  "

user_style = f"#[bg={HOST_BG},fg={HOST_FG}]"
user_string = f"{user_style}  {user}@{host}  "

tmux_style = f"#[bg={TMUX_BG},fg={TMUX_FG}]"
n_tmux_sessions = (
    len(
        str(
            subprocess.run(
                "tmux list-sessions", shell=True, stdout=subprocess.PIPE
            ).stdout.decode()
        ).split("\n")
    )
    - 1
)
tmux_string = f"{tmux_style}  {n_tmux_sessions}  "

print(f"{dir_string}{user_string}{tmux_string}")

# set-option -g status-right "#[bg=$FOLDER_BG,fg=$FOLDER_FG]  #(basename #{pane_current_path})  #[bg=$HOST_BG,fg=$HOST_FG]  #{user}@#h  #[bg=$TMUX_BG,fg=$TMUX_FG]  #(tmux list-sessions | wc -l)  "
