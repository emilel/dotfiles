#!/bin/zsh

# vi mode, no delay entering normal mode
bindkey -v
KEYTIMEOUT=1

# backspace always deletes
bindkey "^?" backward-delete-char

# vi mode binds ^D to list-choices, which hangs on "show all N possibilities?".
# Plain delete instead — an empty line still EOFs out, like any other terminal.
bindkey -M viins "^D" delete-char
bindkey -M vicmd "^D" delete-char

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
autoload -Uz compinit
# compinit's security audit stats every $fpath dir: ~130ms on every single
# shell. Run the full check once a day and take the -C fast path in between.
# The age test goes through an array because [[ ]] never globs. The touch is
# load-bearing: compinit leaves the dump's mtime alone when it has nothing to
# rebuild, so without it every shell past the first day pays again.
_fresh_compdump=("$ZSH_COMPDUMP"(Nmh-24))
if (( $#_fresh_compdump )); then
    compinit -C -d "$ZSH_COMPDUMP"
else
    compinit -d "$ZSH_COMPDUMP"
    [[ -f "$ZSH_COMPDUMP" ]] && touch "$ZSH_COMPDUMP"
fi
unset _fresh_compdump
autoload -Uz bashcompinit && bashcompinit
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
