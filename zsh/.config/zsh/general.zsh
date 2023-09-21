# default applications

export EDITOR=nvim
export MANPAGER='nvim +Man!'

# vi mode

## enable

bindkey -v

## but still have ctrl a

bindkey "^A" vi-beginning-of-line

## escape without delay

KEYTIMEOUT=1

## backspace always deletes

bindkey "^?" backward-delete-char

# history

## set file location

export HISTFILE="$HOME/.config/zsh/.history.zsh"

## how many are loaded in memory

export HISTSIZE=10000

## how many are saved to disk

export SAVEHIST=10000

## don't save duplicates

setopt HIST_IGNORE_ALL_DUPS

## don't find duplicates

setopt HIST_FIND_NO_DUPS

# completion

## enable autocompletion when middle of word is written

zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
compinit
