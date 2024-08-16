#!/bin/zsh

# configure dotfiles
alias conf='cd ~/dotfiles && nvim && cd -'

# add colors to ls
alias ls='ls --color=auto'

# neovim in read only mode
alias view='nvim -R'

# go up a directory
alias up='cd ..'

# reload zsh configuration
alias reload='source ~/.config/zsh/.zshrc'
