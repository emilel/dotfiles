#!/bin/sh
# Claude wants attention: flag the tmux window (waybar's TB reads @claude) and
# pop a mako notification saying which window it is. Called from the hooks in
# claude/.claude/settings.json:
#
#   claude_notify.sh red     blocked on a permission prompt
#   claude_notify.sh green   finished
#
# red outranks green, same as the old inline hooks: a Stop right after a
# permission prompt must not paint the window green. Outside tmux there is no
# flag to set, but the notification still fires.
set -eu

state=${1:-green}
where=claude

if [ -n "${TMUX_PANE:-}" ]; then
    [ "$state" = green ] &&
        [ "$(tmux show -wv -t "$TMUX_PANE" @claude 2>/dev/null || true)" = red ] &&
        exit 0
    tmux set -w -t "$TMUX_PANE" @claude "$state" 2>/dev/null || true
    where=$(tmux display -p -t "$TMUX_PANE" \
        '#{session_name}:#{window_index} #{window_name}' 2>/dev/null || echo claude)
fi

command -v notify-send >/dev/null || exit 0

if [ "$state" = red ]; then
    urgency=critical body="waiting on a permission prompt"
else
    urgency=normal body="done"
fi

# the synchronous hint makes a second notification for the same window replace
# the first instead of stacking
notify-send -a claude -u "$urgency" \
    -h "string:x-canonical-private-synchronous:claude-$where" \
    "$where" "$body"
