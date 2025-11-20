#!/bin/zsh

# show dotfiles first
export LC_COLLATE='C'

# A - don't auto enter on unique filter search
# R - no rollover
# U - show user and group in status bar
export NNN_OPTS='ARU'

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
