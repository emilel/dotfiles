#!/bin/zsh

# show dotfiles first
export LC_COLLATE="C"

# for previews
export NNN_FIFO=/tmp/nnn.fifo

# to open programs
export NNN_OPENER="$HOME/.config/scripts/open.sh"

# don't rm -rf because that's scary
export NNN_TRASH=1

# A - don't auto enter on unique filter match 
# R - no rollover 
# U - show user and group in status bar 
# r - use advcpmv
export NNN_OPTS='ARUr'

# plugins
export NNN_PLUG="p:preview-tui;P:preview-window;d:-!git diff \"$nnn*\";D:-!git diff*;s:-!git status \"\$nnn\";S:-!git status;l:-!git log \"\$nnn*\";L:-!git log*;x:!chmod +x \"\$nnn\"*;y:!wl-copy \"\$nnn\";b:!acp -rv \"\$nnn\" \"\$nnn.bak\"*;g:fzcd;Y:!wl-copy < \"\$nnn\"*"

# cd on quit
n ()
{
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    nnn "$@"
    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}
