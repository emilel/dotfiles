#!/bin/zsh

# Toggle a trailing suffix on the command line (pure helper, echoes the result).
# $1 is the suffix without a leading space, e.g. '| copy'. If the buffer already
# ends with it, strip it (and the space before it); otherwise append it,
# inserting a separating space unless the buffer already ends in one.
_buffer_toggle() {
    local suffix=$1 buf=$2
    if [[ $buf == *"$suffix" ]]; then
        buf=${buf%"$suffix"}
        print -rn -- "${buf% }"
    elif [[ -z $buf || $buf == *' ' ]]; then
        print -rn -- "${buf}${suffix}"
    else
        print -rn -- "${buf} ${suffix}"
    fi
}

# Pipe the command (or the previous command, on an empty line) to `copy`.
toggle_copy() {
    if [[ -z $BUFFER ]]; then
        BUFFER='!!'
        zle expand-history
        BUFFER+=" | copy"
        zle accept-line
    else
        BUFFER=$(_buffer_toggle '| copy' "$BUFFER")
        CURSOR=${#BUFFER}
    fi
}
zle -N toggle_copy
bindkey '^Y' toggle_copy
bindkey -M vicmd '^Y' toggle_copy

# Pipe the command (or the previous command, on an empty line) to `view`.
toggle_view() {
    if [[ -z $BUFFER ]]; then
        BUFFER='!!'
        zle expand-history
        BUFFER+=" | view"
        zle accept-line
    else
        BUFFER=$(_buffer_toggle '| view' "$BUFFER")
        CURSOR=${#BUFFER}
    fi
}
zle -N toggle_view
bindkey '^E' toggle_view
bindkey -M vicmd '^E' toggle_view

# Toggle a 2>&1 redirect on the command line.
redirect_to_stdout() {
    BUFFER=$(_buffer_toggle '2>&1' "$BUFFER")
    CURSOR=${#BUFFER}
}
zle -N redirect_to_stdout
bindkey '^N' redirect_to_stdout
bindkey -M vicmd '^N' redirect_to_stdout

# Jump to the repo root; at the root already, jump to the dir above the repo.
go_to_root() {
    zle push-input
    local repo_root common_dir
    if repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        if [[ $PWD == $repo_root ]]; then
            common_dir=$(git rev-parse --git-common-dir | xargs dirname)
            cd "$common_dir" || return
        else
            cd "$repo_root" || return
        fi
    else
        common_dir=$(git rev-parse --git-common-dir | xargs dirname) || return
        cd "$common_dir" || return
    fi
    zle get-line
    zle reset-prompt
}
zle -N go_to_root
bindkey '^H' go_to_root
bindkey -M viins '^H' go_to_root
bindkey -M vicmd '^H' go_to_root

# make ctrl-w delete the previous word
bindkey -M viins '^W' backward-kill-word
bindkey -M vicmd '^W' backward-kill-word

run_tmux_setup() {
    fd -H '\.sh$' .setup | fzf | xargs sh
}
zle -N run_tmux_setup
bindkey -M viins '^U' run_tmux_setup
bindkey -M vicmd '^U' run_tmux_setup
