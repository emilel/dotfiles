#!/bin/sh
# Claude finished: flag the tmux window (waybar's custom/claude reads @claude)
# and pop a mako notification saying which window it is. Called from the Stop
# hook in claude/.claude/settings.json. Outside tmux there is no flag to set,
# but the notification still fires.
set -eu

# A headless `claude -p` (sdk-cli; interactive is cli) is a script's, not
# yours: whatever ran it reports its end, so no flag, no bell, no popup here.
case ${CLAUDE_CODE_ENTRYPOINT:-} in sdk-*) exit 0 ;; esac

where=claude

# A turn a background event started -- a watch line, a subagent's report --
# ends with nothing for you to look at: only a turn you started says "done".
# The Stop hook's stdin names the transcript, whose last prompt says who.
origin=$(python3 -c '
import json, sys
path = json.load(sys.stdin).get("transcript_path", "")
with open(path, "rb") as log:
    log.seek(0, 2)
    log.seek(max(0, log.tell() - 2_000_000))
    lines = log.read().decode("utf-8", "replace").splitlines()
for line in reversed(lines):
    try:
        row = json.loads(line)
    except ValueError:
        continue
    if "turnOrigin" in row:
        print(row["turnOrigin"])
        break
' 2>/dev/null || true)
[ -z "$origin" ] || [ "$origin" = human ] || exit 0

if [ -n "${TMUX_PANE:-}" ]; then
    tmux set -w -t "$TMUX_PANE" @claude green 2>/dev/null || true

    # Ring the bell ourselves, into the pane's own tty. The window colour comes
    # off tmux's bell flag, and claude's own bell is off (preferredNotifChannel):
    # it also rang on its idle notice a minute later, re-greening a window
    # already seen. Rung here, colour and popup leave on this one call. tmux
    # still drops a bell for the window an attached client sits on, which is
    # the window already in front of you; @claude covers that one for waybar.
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

# the synchronous hint makes a second notification for the same window replace
# the first instead of stacking
notify-send -a claude -u normal \
    -h "string:x-canonical-private-synchronous:claude-$where" \
    "$where" "done"
