#!/bin/bash

session=$(tmux list-sessions -F '#S' | fzf)
kitty tmux attach-session -t $session &disown
