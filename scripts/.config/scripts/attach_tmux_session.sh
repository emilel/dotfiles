#!/bin/zsh -f

set -e

session=$(tmux list-sessions -F "#{session_name}" | fzf --no-info --no-scrollbar --no-color --pointer=' ' --layout=reverse)
swaymsg exec "foot tmux attach -t $session"
