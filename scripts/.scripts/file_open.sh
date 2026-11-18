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

dir=$(mktemp -d) || exit 1
trap 'rm -rf "$dir"' EXIT # a lingering app keeps its open log; the rc is lost
n=0
spawn() {
    n=$((n + 1))
    (
        trap '' HUP
        "$@" >"$dir/$n.log" 2>&1
        echo $? >"$dir/$n.rc"
    ) </dev/null >/dev/null 2>&1 &
}

# xdg-open takes one file, which would mean one viewer window per image. So
# group files by their default app and hand each app all of its files at
# once: `open *.png` is one swayimg you can page through.
if [ $# -eq 1 ] || [ "$opener" != xdg-open ] ||
    ! command -v gtk-launch >/dev/null 2>&1; then
    for arg in "$@"; do spawn "$opener" "$arg"; done
else
    tab=$(printf '\t')
    for arg in "$@"; do
        case $arg in
            *://* | mailto:*) app= ;;
            *) app=$(xdg-mime query default \
                "$(xdg-mime query filetype "$arg" 2>/dev/null)" 2>/dev/null) ;;
        esac
        # No app found: let xdg-open try, and fail with its own message.
        [ -n "$app" ] || app=-
        printf '%s\t%s\n' "$app" "$arg" >>"$dir/map"
    done
    # shellcheck disable=SC2013 # desktop ids have no spaces
    for app in $(cut -f1 "$dir/map" | sort -u); do
        set --
        while IFS=$tab read -r a f; do
            [ "$a" = "$app" ] && set -- "$@" "$f"
        done <"$dir/map"
        if [ "$app" = - ] || [ $# -eq 1 ]; then
            for f in "$@"; do spawn xdg-open "$f"; done
        else
            spawn gtk-launch "$app" "$@"
        fi
    done
fi

# Watch half a second. Anything that dies that fast never opened a window, so
# it failed and the reason is worth printing; anything still alive is an app,
# and what an app writes from here on is noise.
i=0
while [ "$(find "$dir" -name '*.rc' | wc -l)" -lt "$n" ] && [ "$i" -lt 5 ]; do
    sleep 0.1
    i=$((i + 1))
done

status=0
for rc in "$dir"/*.rc; do
    [ -f "$rc" ] || continue
    s=$(cat "$rc")
    [ "$s" -eq 0 ] && continue
    cat "${rc%.rc}.log" >&2
    status=$s
done
exit "$status"
