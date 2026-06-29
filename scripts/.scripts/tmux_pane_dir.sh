#!/bin/sh
# Print the basename of $1 (default: $PWD), with a '*' suffix when it is a dirty
# git work tree. The git check is cached for $ttl seconds so the tmux status bar,
# which redraws every second, doesn't shell out to git on every single redraw.
set -eu

dir=${1:-$PWD}
name=$(basename "$dir")

ttl=7
cache_dir="${TMPDIR:-/tmp}/tmux-git-dirty-$(id -u)"
mkdir -p "$cache_dir"
key=$(printf '%s' "$dir" | cksum | cut -d' ' -f1)
cache="$cache_dir/$key"

now=$(date +%s)
ts=0
flag=""
if [ -f "$cache" ]; then
    read -r ts flag <"$cache" || true
fi

if [ $((now - ts)) -ge "$ttl" ]; then
    flag=""
    if git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1 &&
        [ -n "$(git -C "$dir" status --porcelain 2>/dev/null)" ]; then
        flag="*"
    fi
    printf '%s %s\n' "$now" "$flag" >"$cache"
fi

printf '%s%s' "$name" "$flag"
