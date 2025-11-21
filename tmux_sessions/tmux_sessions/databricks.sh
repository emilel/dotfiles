#!/usr/bin/env bash
set -e

SESSION=databricks
WINDOW=work
ROOT=~/work/databricks
CODEX_ROOT=~/codex
CODEX_DIR="$CODEX_ROOT/$(basename "$ROOT")"
SHELL_CMD="${SHELL:-/bin/zsh}"

# create codex dir if missing, then init git once
if [ ! -d "$CODEX_DIR" ]; then
    mkdir -p "$CODEX_DIR"
    git init "$CODEX_DIR"
fi

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -d -s "$SESSION" -n "$WINDOW" -c "$ROOT" \
        "$SHELL_CMD -lc 'cd \"$ROOT\" && nvim; exec $SHELL_CMD'"

    tmux split-window -h -t "$SESSION":1 -c "$ROOT"

    tmux split-window -v -t "$SESSION":1.1 -c "$CODEX_DIR"
    tmux send-keys -t "$SESSION":1.2 "cd \"$CODEX_DIR\" && codex; exec $SHELL_CMD" C-m

    tmux select-pane -t "$SESSION":1.0 -T "nvim"
    tmux select-pane -t "$SESSION":1.1 -T "terminal"
    tmux select-pane -t "$SESSION":1.2 -T "codex"
    tmux select-pane -t "$SESSION":1.0
fi

tmux attach -t "$SESSION"
