#!/bin/sh
# git worktree multitool for the bare-repo + sibling-worktrees layout:
#
#     project/
#     |- .bare/            git data (bare repo)
#     |- .git              file: "gitdir: ./.bare"
#     |- main/             worktree -> branch main
#     `- feature/x/        worktree -> branch feature/x  (dirs mirror branch names)
#
# Usage:
#   git_worktree.sh clone <url> [name]     bare-clone, fetch, add the default worktree
#   git_worktree.sh new   <branch> [base]  branch off fresh origin/<base>, add worktree
#   git_worktree.sh add   <branch> [dir]   add a worktree for an existing branch
#   git_worktree.sh sync                   fetch + fast-forward the current worktree
#   git_worktree.sh remove [path]          remove a worktree (default: the current one)
#   git_worktree.sh prune-merged           remove worktrees merged into origin's default
#   git_worktree.sh switch                 fzf-pick a worktree and print its path
#   git_worktree.sh list                   list worktrees
#
# Commands that create or locate a worktree print its absolute path on stdout, so
# a shell wrapper can `cd` into it and agents can capture it. Every command
# fetches first and only ever fast-forwards, so worktrees don't drift from origin.
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

# The directory that holds .bare (parent of the common git dir).
project_root() {
    common=$(git rev-parse --git-common-dir)
    (CDPATH='' cd -- "$common/.." && pwd)
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

    mkdir -p "$name"
    git clone --bare "$url" "$name/.bare" 1>&2
    echo "gitdir: ./.bare" >"$name/.git"
    git -C "$name" config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
    git -C "$name" fetch --quiet origin 1>&2
    git -C "$name" remote set-head origin --auto 1>&2 || true

    db=$(git -C "$name" symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null || true)
    db=${db#origin/}
    [ -n "$db" ] || db=main

    dest=$(abspath "$name")/$db # absolute, so `git -C` doesn't reinterpret it
    if git -C "$name" show-ref --verify --quiet "refs/heads/$db"; then
        git -C "$name" worktree add --quiet "$dest" "$db" 1>&2
    else
        git -C "$name" worktree add --quiet -b "$db" "$dest" "origin/$db" 1>&2
    fi
    git -C "$name" branch --quiet --set-upstream-to="origin/$db" "$db" 2>/dev/null || true

    # A bare clone copies every remote branch into refs/heads with no upstream.
    # Drop those strays (keep the checked-out default); add/new recreate branches
    # on demand WITH origin tracking, which is what keeps worktrees from drifting.
    git -C "$name" for-each-ref --format='%(refname:short)' refs/heads/ | while read -r b; do
        [ "$b" = "$db" ] && continue
        git -C "$name" branch -D "$b" >/dev/null 2>&1 || true
    done

    printf '%s\n' "$dest"
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

    dest=$(project_root)/$branch
    [ ! -e "$dest" ] || die "path already exists: $dest"
    git branch --quiet --no-track "$branch" "$start"
    git worktree add --quiet "$dest" "$branch" 1>&2
    abspath "$dest"
}

cmd_add() {
    [ "$#" -ge 1 ] || die "usage: add <branch> [dir]"
    branch=$1
    git fetch --quiet --prune origin 1>&2

    dest=$(project_root)/${2:-$branch}
    [ ! -e "$dest" ] || die "path already exists: $dest"
    if git show-ref --verify --quiet "refs/heads/$branch"; then
        git worktree add --quiet "$dest" "$branch" 1>&2
    elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
        git worktree add --quiet --track -b "$branch" "$dest" "origin/$branch" 1>&2
    else
        die "no such branch (local or origin): $branch (use 'new')"
    fi
    abspath "$dest"
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
    root=$(project_root)
    if [ "$#" -ge 1 ]; then
        target=$(abspath "$1")
    else
        target=$(git rev-parse --show-toplevel)
    fi
    CDPATH='' cd -- "$root" # step out so we can remove the current worktree
    git worktree remove --force "$target" 1>&2 || die "cannot remove worktree: $target"
    printf '%s\n' "$root"
}

cmd_prune_merged() {
    git fetch --quiet --prune origin 1>&2
    base=$(default_branch)
    root=$(project_root)
    CDPATH='' cd -- "$root"
    git worktree list --porcelain |
        awk '/^worktree /{w=$2} /^branch /{print w" "$2}' |
        while read -r path ref; do
            branch=${ref#refs/heads/}
            if [ "$branch" = "$base" ]; then
                continue
            fi
            if git merge-base --is-ancestor "$ref" "refs/remotes/origin/$base" 2>/dev/null; then
                if git worktree remove --force "$path" 1>&2; then
                    echo "removed merged: $branch" >&2
                fi
            fi
        done
}

# fzf-pick a worktree and print its path. Picks on the branch, not the dir: a
# slashed branch lands in a dir named for it only if this script made the
# worktree (feature/x -> feature/x); worktrees made elsewhere flatten it
# (feature-x), so the dir name is not something to read a branch off. The
# harness's throwaway agent worktrees under .claude/worktrees/ are hidden;
# bare entries have no branch line at all, so they drop out for free.
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
