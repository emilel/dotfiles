#!/bin/zsh

# copy depending on display server
if grep -qi microsoft /proc/version; then
    alias copyr='clip.exe'
elif [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    alias copyr='wl-copy'
else
    alias copyr='xclip -selection clipboard'
fi

# print what's copied
copy() {
    text=$(perl -pe 'chomp if eof' </dev/stdin)
    printf $text'\n'
    printf $text | copyr
}

# enable vi mode
bindkey -v

# witout delay
KEYTIMEOUT=1

# copy to global clipboard
zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | copy
	zvm_exit_visual_mode
}

# backspace always deletes
bindkey "^?" backward-delete-char

# save history
export HISTFILE="$HOME/zsh/.history"

# search history
bindkey '^R' history-incremental-search-backward

# history in memory
export HISTSIZE=10000

# history on disk
export SAVEHIST=10000

# ignore duplicates
setopt HIST_IGNORE_ALL_DUPS

## don't find duplicates
setopt HIST_FIND_NO_DUPS

# set LS_COLORS variable for ls and tree
eval $(dircolors -b)
