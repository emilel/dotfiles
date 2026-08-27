#!/bin/sh
# Waybar's custom/claude: the tmux windows wanting attention, in the colours
# tmux paints them -- red for a claude blocked on a permission prompt (@claude,
# set by the hooks in claude/.claude/settings.json), green for a bell (a claude
# that finished, or anything else that rang). @claude is also set while the
# window is the current one, which the bell flag never is: tmux drops alerts for
# the window an attached client is on, so a claude finishing in the session
# you're sitting in would otherwise go unreported once you walk away.
#
# The window actually on screen is dropped and its @claude cleared (viewing an
# alert is what clears it everywhere else); sway's focused window carries the
# tmux "session:index name" as its title, see set-titles-string. Nothing
# waiting -> no output -> waybar hides the module.
set -eu

RED='#d75f5f'   # tmux BELL_PERM_BG, colour167
GREEN='#5faf5f' # tmux BELL_BG, colour71

onscreen=$(swaymsg -t get_tree 2>/dev/null |
    jq -r 'recurse(.nodes[]?, .floating_nodes[]?) | select(.focused) | .name // empty')
[ -z "$onscreen" ] || tmux set -w -t "${onscreen%% *}" -u @claude 2>/dev/null || true

tmux list-windows -a -F '#{@claude}|#{window_bell_flag}|#{session_name}:#{window_index} #{window_name}' 2>/dev/null |
    awk -F'|' -v red="$RED" -v green="$GREEN" -v onscreen="$onscreen" '
        $1 != "red" && $1 != "green" && $2 != 1 { next }
        {
            what = $0
            sub(/^[^|]*\|[^|]*\|/, "", what)
            if (what == onscreen) next
            gsub(/&/, "\\&amp;", what)
            gsub(/</, "\\&lt;", what)
            printf "%s<span color=\"%s\">%s</span>", sep, ($1 == "red" ? red : green), what
            sep = "  "
        }
        END { if (sep) print "" }'
