#!/bin/bash

folder=/home/emil/dotfiles
tmux rename-session conf
tmux rename-window all
tmux send-keys conf Enter
tmux new-window -a -c $folder/nvim/.config/nvim -n vim
tmux send-keys "nvim -c 'Telescope find_files'" Enter
tmux select-window -t 1
tmux select-pane -L
