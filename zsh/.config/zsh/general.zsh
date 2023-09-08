# default applications

export EDITOR=nvim

# vi mode

## enable

bindkey -v

## escape without delay

KEYTIMEOUT=1

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
