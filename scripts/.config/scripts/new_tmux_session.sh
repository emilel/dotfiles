#!/bin/zsh -f

SESSION_NAMES=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten")

for SESSION_NAME in "${SESSION_NAMES[@]}"; do
    if ! tmux has-session -t $SESSION_NAME 2>/dev/null; then
        tmux new-session -s $SESSION_NAME -n shell
        exit 0
    fi
done
