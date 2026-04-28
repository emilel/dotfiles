#!/bin/zsh

# don't save history
unset HISTFILE

# load the normal config and map enter to append "; exit" (run one command)
source ~/.config/zsh/.zshrc
bindkey -s '^M' '; exit\n'
