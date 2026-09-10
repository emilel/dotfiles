#!/bin/sh
# git worktree multitool for the worktrees-inside-the-checkout layout:
#
#     project/                 normal clone, sits on the default branch
#     |- .git/
#     `- .worktrees/           one dir per extra branch, gitignored
#        |- feature-x/         worktree -> branch feature/x  (slashes flattened)
#        `- topic/             worktree -> branch topic
#
# Usage:
#   git_worktree.sh clone <url> [name]     clone, ignore .worktrees/
#   git_worktree.sh new   <branch> [base]  branch off fresh origin/<base>, add worktree
#   git_worktree.sh add   <branch>         add a worktree for an existing branch
#   git_worktree.sh sync                   fetch + fast-forward the current worktree
#   git_worktree.sh remove [path]          remove a worktree (default: the current one)
#   git_worktree.sh prune-merged           remove worktrees merged into origin's default
#   git_worktree.sh switch                 fzf-pick a worktree and print its path
#   git_worktree.sh list                   list worktrees
#
# Commands that create or locate a worktree print its absolute path on stdout, so
# a shell wrapper can `cd` into it and agents can capture it. Every command
# fetches first and only ever fast-forwards, so worktrees don't drift from origin.
# Every command also works from inside a linked worktree: paths hang off the main
# checkout, which is where the common git dir lives, not off $PWD.
set -eu

die() {
    echo "git_worktree: $*" >&2
    exit 1
}

# Name of origin's default branch (e.g. main), with sensible fallbacks.
default_branch() {
    ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)
    if [ -n "$ref" ]; then
        printf '%s\n' "${ref#origin/}"
        return 0
    fi
    for cand in main master; do
        if git show-ref --verify --quiet "refs/remotes/origin/$cand"; then
            printf '%s\n' "$cand"
            return 0
        fi
    done
    printf 'main\n'
}

# The main checkout: the dir holding the common .git, reached from any worktree.
main_checkout() {
    common=$(git rev-parse --git-common-dir)
    (CDPATH='' cd -- "$common/.." && pwd)
}

# A branch's worktree dir: the name with its slashes flattened, under .worktrees/.
worktree_for() {
    printf '%s/.worktrees/%s\n' "$(main_checkout)" "$(printf '%s' "$1" | tr '/' '-')"
}

# Keep .worktrees/ out of `git status`. In .git/info/exclude, not .gitignore: the
# layout is this machine's choice, and a clone of someone else's repo is not the
# place to commit it. Idempotent — every command that makes a worktree calls it.
ignore_worktrees() {
    excl=$(git -C "$1" rev-parse --git-common-dir)/info/exclude
    grep -qxF '/.worktrees/' "$excl" 2>/dev/null && return 0
    mkdir -p "${excl%/*}"
    echo '/.worktrees/' >>"$excl"
}

abspath() {
    (CDPATH='' cd -- "$1" && pwd)
}

cmd_clone() {
    [ "$#" -ge 1 ] || die "usage: clone <url> [name]"
    url=$1
    base=${url##*/}
    name=${2:-${base%.git}}
    [ ! -e "$name" ] || die "path already exists: $name"

    git clone --quiet "$url" "$name" 1>&2
    git -C "$name" remote set-head origin --auto 1>&2 || true
    ignore_worktrees "$name"
    abspath "$name"
}

cmd_new() {
    [ "$#" -ge 1 ] || die "usage: new <branch> [base]"
    branch=$1
    base=${2:-$(default_branch)}

    git fetch --quiet --prune origin 1>&2
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        die "branch already exists: $branch (use 'add')"
    fi
    if git show-ref --verify --quiet "refs/remotes/origin/$base"; then
        start="origin/$base"
    elif git show-ref --verify --quiet "refs/heads/$base"; then
        start="$base"
    else
        die "no such base branch: $base"
    fi

    dest=$(worktree_for "$branch")
    [ ! -e "$dest" ] || die "path already exists: $dest"
    ignore_worktrees .
    git branch --quiet --no-track "$branch" "$start"
    git worktree add --quiet "$dest" "$branch" 1>&2
    printf '%s\n' "$dest"
}

cmd_add() {
    [ "$#" -ge 1 ] || die "usage: add <branch>"
    branch=$1
    git fetch --quiet --prune origin 1>&2

    dest=$(worktree_for "$branch")
    [ ! -e "$dest" ] || die "path already exists: $dest"
    ignore_worktrees .
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git worktree add --quiet "$dest" "$branch" 1>&2
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        git worktree add --quiet --track -b "$branch" "$dest" "origin/$branch" 1>&2
    else
        die "no such branch (local or origin): $branch (use 'new')"
    fi
    printf '%s\n' "$dest"
}

cmd_sync() {
    git fetch --quiet --prune origin 1>&2
    upstream=$(git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || true)
    [ -n "$upstream" ] || die "no upstream for the current branch; nothing to sync"
    git merge --ff-only "$upstream" 1>&2 ||
        die "cannot fast-forward onto $upstream (diverged); resolve manually"
    echo "synced onto $upstream" >&2
}

cmd_remove() {
    root=$(main_checkout)
    if [ "$#" -ge 1 ]; then
        target=$(abspath "$1")
    else
        target=$(git rev-parse --show-toplevel)
    fi
    [ "$target" != "$root" ] || die "that is the main checkout, not a worktree"
    CDPATH='' cd -- "$root" # step out so we can remove the current worktree
    git worktree remove --force "$target" 1>&2 || die "cannot remove worktree: $target"
    printf '%s\n' "$root"
}

cmd_prune_merged() {
    git fetch --quiet --prune origin 1>&2
    base=$(default_branch)
    root=$(main_checkout)
    CDPATH='' cd -- "$root"
    git worktree list --porcelain |
        awk '/^worktree /{w=$2} /^branch /{print w" "$2}' |
        while read -r path ref; do
            branch=${ref#refs/heads/}
            if [ "$branch" = "$base" ] || [ "$path" = "$root" ]; then
                continue
            fi
            if git merge-base --is-ancestor "$ref" "refs/remotes/origin/$base" 2>/dev/null; then
                if git worktree remove --force "$path" 1>&2; then
                    echo "removed merged: $branch" >&2
                fi
            fi
        done
}

# fzf-pick a worktree and print its path. Picks on the branch, not the dir: dirs
# flatten a slashed branch (feature/x -> feature-x), so the dir name is not
# something to read a branch off. The main checkout is offered like any other —
# it is a worktree too — while the harness's throwaway agent worktrees under
# .claude/worktrees/ are hidden.
cmd_switch() {
    line=$(git worktree list --porcelain | awk '
        /^worktree /  { p = substr($0, 10); skip = (p ~ /\/\.claude\/worktrees\//) }
        /^branch /    { b = $2; sub(/^refs\/heads\//, "", b); if (!skip) print b "\t" p }
        /^detached$/  { if (!skip) print "(detached)\t" p }
    ' | fzf --delimiter='\t' --with-nth=1) || exit 1
    [ -n "$line" ] || exit 1
    printf '%s\n' "$line" | cut -f2-
}

cmd_list() {
    git worktree list
}

[ "$#" -ge 1 ] || die "usage: git_worktree.sh <clone|new|add|sync|remove|prune-merged|switch|list> ..."
sub=$1
shift
case "$sub" in
    clone) cmd_clone "$@" ;;
    new) cmd_new "$@" ;;
    add) cmd_add "$@" ;;
    sync) cmd_sync "$@" ;;
    remove) cmd_remove "$@" ;;
    prune-merged) cmd_prune_merged "$@" ;;
    switch) cmd_switch "$@" ;;
    list) cmd_list "$@" ;;
    *) die "unknown subcommand: $sub" ;;
esac
