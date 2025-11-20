#!/bin/zsh

session_names=("one" "two" "three" "four" "five" "six" "seven" "eight" "nine" "ten")

for name in "${session_names[@]}"; do
    tmux has-session -t "$name" 2>/dev/null

    if [ $? != 0 ]; then
        tmux new-session -s "$name"
        exit 0
    fi
done

echo "All sessions already exist."
