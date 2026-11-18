#!/bin/zsh

# show dotfiles first
export LC_COLLATE='C'

# A - don't auto enter on unique filter search
# R - no rollover
# U - show user and group in status bar
# c - opener runs in the terminal, so it can start an editor
# e - text in $EDITOR; the rest goes to the opener
export NNN_OPTS='ARUce'
# json to $EDITOR, the rest to xdg-open (swayimg, mpv)
export NNN_OPENER="$HOME/.scripts/nnn_open.sh"

# plugins
# x: toggle executable bit
export NNN_PLUG='x:![ -x "$nnn" ] && chmod -x "$nnn" || chmod +x "$nnn"*;n:!nvim*'

# cd on quit with ctrl g
n ()
{
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn "$@"
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}
