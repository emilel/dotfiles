#!/bin/bash

session=$(tmux list-sessions -F '#S' | grep -v "_\w" | fzf)
kitty tmux new-session -t $session &disown
