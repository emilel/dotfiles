#!/bin/zsh

SCRIPT_DIR="$HOME/.scripts"
export PATH="$PATH:$SCRIPT_DIR"

# tmux helpers
alias t="$SCRIPT_DIR/tmux_new_session.sh"
alias ta="$SCRIPT_DIR/tmux_attach.sh"
alias tt="$SCRIPT_DIR/tmux_run_template.sh"

# open in the desktop's app, detached — never blocks the prompt or a tmux popup
alias open="$SCRIPT_DIR/file_open.sh"

# sway helpers
alias rnw="$SCRIPT_DIR/sway_rename_workspace.sh"
alias lock="$SCRIPT_DIR/sway_lock.sh"
alias so="$SCRIPT_DIR/sway_screen_off.sh"

# NB: gct (git clone worktree) is a function in commands/git.zsh, not an alias.
