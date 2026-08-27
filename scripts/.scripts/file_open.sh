#!/bin/sh
# Hand files/URLs to the desktop's default app and come straight back to the
# prompt. Three things the obvious `xdg-open x.pdf &` gets wrong:
#   - stdin: a child still holding the terminal keeps a tmux popup alive after
#     the shell has exited, and then no key on earth closes it.
#   - output: firefox and every GTK app chatter at the prompt forever.
#   - SIGHUP: the viewer should outlive the terminal it was opened from.
# So: stdin from /dev/null, output to a temp log, HUP ignored. Errors still
# show — a launch that dies inside the grace window (no handler, bad url) gets
# its output printed and its status passed on.
set -u

[ $# -gt 0 ] || {
    echo "usage: ${0##*/} <file|url>..." >&2
    exit 64
}

if grep -qi microsoft /proc/version 2>/dev/null; then
    opener=explorer.exe
else
    opener=xdg-open
fi
command -v "$opener" >/dev/null 2>&1 || {
    echo "${0##*/}: $opener not found" >&2
    exit 127
}

# A typo'd path is the common failure and xdg-open's own message for it is
# useless, so say it here, before anything is launched.
for arg in "$@"; do
    case $arg in
        *://* | mailto:*) ;;
        *) [ -e "$arg" ] || {
            echo "${0##*/}: no such file: $arg" >&2
            exit 66
        } ;;
    esac
done

log=$(mktemp) || exit 1
rc="$log.rc"
(
    trap '' HUP
    "$opener" "$@" >"$log" 2>&1
    echo $? >"$rc"
    sleep 1 # long enough for the watcher below to read it first
    rm -f "$log" "$rc"
) </dev/null >/dev/null 2>&1 &

# Watch half a second. Anything that dies that fast never opened a window, so
# it failed and the reason is worth printing; anything still alive is an app,
# and what an app writes from here on is noise.
i=0
while [ ! -f "$rc" ] && [ "$i" -lt 5 ]; do
    sleep 0.1
    i=$((i + 1))
done
[ -f "$rc" ] || exit 0

status=$(cat "$rc")
[ "$status" -eq 0 ] || cat "$log" >&2
exit "$status"
