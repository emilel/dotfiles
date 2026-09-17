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

    # Ring the bell ourselves, into the pane's own tty. The window colour comes
    # off tmux's bell flag, and the bell claude rings is a separate event on its
    # own schedule -- with the terminal bell off, one that never arrives. That
    # was the whole gap: the popup fired from here and the colour waited on
    # something else. Rung here, both leave on this one call. tmux still drops a
    # bell for the window an attached client sits on, which is the window
    # already in front of you; @claude covers that one for waybar.
    tty=$(tmux display -p -t "$TMUX_PANE" '#{pane_tty}' 2>/dev/null || true)
    if [ -n "$tty" ]; then
        { printf '\a' >"$tty"; } 2>/dev/null || true
    fi

    # Repaint now rather than up to status-interval (1s) from now, so the colour
    # does not still trail the popup by a frame.
    tmux refresh-client -S 2>/dev/null || true

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
