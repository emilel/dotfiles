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

# Where ^H jumps from $PWD (pure helper, echoes the dir): the repo root, or —
# standing on it already — the dir holding the repo's common .git, i.e. the main
# checkout a worktree hangs off. Standing on *that*, or outside a repo, $HOME.
# Fails, silently, only at $HOME.
_repo_jump_target() {
    local root
    if root=$(git rev-parse --show-toplevel 2>/dev/null) && [[ $PWD != $root ]]; then
        print -r -- "$root"
        return
    fi
    if root=$(git rev-parse --git-common-dir 2>/dev/null) && [[ ${root:A:h} != $PWD ]]; then
        print -r -- "${root:A:h}"
        return
    fi
    [[ $PWD != $HOME ]] || return 1
    print -r -- "$HOME"
}

# The line a jump runs (pure helper, echoes it). Quoted, because a worktree dir
# is named after its branch and branches take spaces.
_cd_command() {
    print -rn -- "cd -- ${(q)1}"
}

# Run a jump as a real `cd` line instead of cd'ing inside the widget: pure fills
# the branch in from precmd, which reset-prompt never re-runs, so an in-widget
# cd leaves the old branch on screen. accept-line draws a fresh prompt below
# rather than over the old one; push-input parks the half-typed line for zsh to
# restore after the cd.
#
# push-input goes last, once the destination is known and nothing between it and
# accept-line can fail. It is the one step here that outlives the widget: park
# the line first and a widget that dies before accepting — ^C out of a picker
# signals the whole foreground group — leaves it on the buffer stack, where zsh
# hands it back later glued onto an unrelated line.
_jump_to() {
    zle push-input
    BUFFER=$(_cd_command "$1")
    zle accept-line
}

# Jump to the repo root; at the root already, jump home.
go_to_root() {
    local dir
    dir=$(_repo_jump_target) || return
    _jump_to "$dir"
}
zle -N go_to_root
bindkey '^H' go_to_root
bindkey -M viins '^H' go_to_root
bindkey -M vicmd '^H' go_to_root

# Jump to another worktree of this repo (same picker as `gw`). Silent outside a
# repo — git's "not a git repository" would land mid-prompt; fzf draws on the
# tty, so hiding stderr doesn't hide the picker. A cancelled picker has nothing
# to undo, the line never having been parked; the redraw is only for a picker
# that failed to give back the screen it took.
go_to_worktree() {
    local dir
    dir=$(git_worktree.sh switch 2>/dev/null) || { zle reset-prompt; return }
    _jump_to "$dir"
}
zle -N go_to_worktree
bindkey '^T' go_to_worktree
bindkey -M viins '^T' go_to_worktree
bindkey -M vicmd '^T' go_to_worktree

# Jump up a dir; nothing to do at /.
go_up() {
    [[ $PWD != / ]] || return
    _jump_to ..
}
zle -N go_up
bindkey '^K' go_up
bindkey -M viins '^K' go_up
bindkey -M vicmd '^K' go_up

# Pasted text minus blank lines before and after it (pure helper, echoes the
# result): copying a command usually grabs its newline too, which leaves the
# pasted line sitting above an empty one. Indentation on the first line stays —
# a leading space keeps a command out of history.
_paste_trim() {
    emulate -L zsh -o extendedglob
    local text=${1##([[:blank:]]#$'\n')#}
    print -rn -- "${text%%($'\n'[[:blank:]]#)#}"
}

paste_trimmed() {
    local text
    zle .bracketed-paste text
    LBUFFER+=$(_paste_trim "$text")
}
zle -N bracketed-paste paste_trimmed

# make ctrl-w delete the previous word
bindkey -M viins '^W' backward-kill-word
bindkey -M vicmd '^W' backward-kill-word

run_tmux_setup() {
    fd -H '\.sh$' .setup | fzf | xargs sh
}
zle -N run_tmux_setup
bindkey -M viins '^U' run_tmux_setup
bindkey -M vicmd '^U' run_tmux_setup

# M-r closes the M-r scratch popup. A tmux popup swallows every key, so only
# this shell exiting can close it, and ^D only EOFs on an empty line — a stray
# half-typed line would otherwise wedge the whole client. TMUX_POPUP is set by
# the binding in tmux.conf, so this is dead weight in a normal shell.
if [[ -n $TMUX_POPUP ]]; then
    popup_close() { exit }
    zle -N popup_close
    bindkey '^[r' popup_close
    bindkey -M vicmd '^[r' popup_close
fi
