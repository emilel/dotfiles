#!/bin/zsh

# configure dotfiles
alias conf='cd ~/dotfiles && nvim && cd -'

# add colors to ls
alias ls='ls --color=auto'

# neovim in read only mode
alias view='nvim -R'

# temporary neovim buffer
alias temp='nvim +Temp'

# go up a directory
alias up='cd ..'

# go back a directory
alias back='cd -'

# reload zsh configuration
alias reload='source ~/.config/zsh/.zshrc'

# add to local gitignore
alias lgi="$EDITOR .git/info/exclude"

# get ip
alias whatsmyip='curl icanhazip.com'

# python
alias py='python3'

# open notes
alias notes='pushd ~/notes && nvim && popd'

# go to the output of the last command
cdlast() {
  cd -P -- "$(!!)"
}
