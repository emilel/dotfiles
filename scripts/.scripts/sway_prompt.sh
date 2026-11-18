#!/bin/sh
# The fullscreen dimmed prompt (tofi) behind $mod+d, $mod+m and $mod+t. Reads menu items on stdin and prints
# what was picked -- or, since require-match=false, whatever was typed.
# Escape quits without printing, and exits non-zero.
#
#   sway_prompt.sh --prompt-text 'rename: ' <items
#   sway_prompt.sh --run                    # list $PATH instead of stdin
#
# Look lives in tofi/.config/tofi/config; only the font comes from here,
# because a font *path* skips fontconfig (much faster) and tofi's config file
# can't expand ~.
set -eu

font="$HOME/.fonts/adobe-fonts/source-code-pro/OTF/SourceCodePro-Regular.otf"
[ -f "$font" ] || font='Source Code Pro'

bin=tofi
if [ "${1:-}" = --run ]; then
    bin=tofi-run
    shift
fi

exec "$bin" --font "$font" "$@"
