#!/bin/zsh

# copy depending on display server
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  alias copyr='wl-copy'
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
  alias copyr='xclip -selection clipboard'
elif grep -qi microsoft /proc/version; then
  alias copyr='clip.exe'
else
  alias copyr='echo "No clipboard found"'
fi

# print what's copied
copy() {
    text=$(perl -pe 'chomp if eof' </dev/stdin)
    printf "%s\n" "$text"
    printf "%s" "$text" | copyr
}

# copy command and output
copyc() {
  local command="$1"
  shift
  local output=$("$command" "$@" 2>&1 | perl -pe 'chomp if eof')
  printf "> %s %s\n\n%s" "$command" "$*" "$output" | copyr
  printf "%s\n" "$output"
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
setopt appendhistory
export HISTFILE=~/.zsh/.history

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

# no case and find middle of word when autocompleting
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
