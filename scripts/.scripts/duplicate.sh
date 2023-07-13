#!/bin/bash

if [ $# -eq 1 ]
then
    sessions=$(tmux list-session -F "#S")
    new_session=$(~/.scripts/get_new_session_name.py $1 $sessions)
    tmux new-session -t $1 -s $new_session
else
    session=$(tmux list-session -F "#S" | grep -v - | fzf)
    sessions=$(tmux list-session -F "#S")
    new_session=$(~/.scripts/get_new_session_name.py $session $sessions)
    tmux new-session -t $session
fi
