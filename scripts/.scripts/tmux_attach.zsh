#!/bin/zsh

tmux attach-session -t $(tmux list-sessions -F "#{session_name}" | fzf --select-1)
