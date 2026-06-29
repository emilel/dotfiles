#!/bin/zsh

# vi mode, no delay entering normal mode
bindkey -v
KEYTIMEOUT=1

# backspace always deletes
bindkey "^?" backward-delete-char

# don't yank into the clipboard when pressing x in normal mode
bindkey -M vicmd 'x' vi-delete-char

# history
export HISTFILE=~/.zsh/.history
export HISTSIZE=10000
export SAVEHIST=10000
setopt appendhistory
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# no error message when a glob matches nothing
setopt NULL_GLOB

# colours for ls and tree
eval $(dircolors -b)

# completion: case-insensitive, match the middle of a word. Keep the generated
# dump in the cache dir instead of polluting $ZDOTDIR (and the repo).
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
[[ -d "${ZSH_COMPDUMP:h}" ]] || mkdir -p "${ZSH_COMPDUMP:h}"
autoload -Uz compinit && compinit -d "$ZSH_COMPDUMP"
autoload -Uz bashcompinit && bashcompinit
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
