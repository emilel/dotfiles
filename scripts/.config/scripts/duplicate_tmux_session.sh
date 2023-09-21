#!/bin/zsh -f

set -e

session=$(tmux list-sessions -F "#{session_name}" | grep -v - | fzf --no-info --no-scrollbar --no-color --pointer=' ' --layout=reverse)
swaymsg exec "foot tmux new-session -t $session"
