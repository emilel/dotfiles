#!/bin/zsh

# add colors to ls
alias ls='ls --color=auto'

# neovim in read only mode
alias view='nvim -R'

# temporary neovim buffer
alias temp='nvim +TempFile'

# edit clipboard
alias clip='nvim +Clip'

# go up a directory
alias up='cd ..'

# go back a directory
alias back='cd -'

# reload zsh configuration
alias reload='source ~/.config/zsh/.zshrc'

# get ip
alias whatsmyip='curl icanhazip.com'

# python
alias py='python3'
alias ipython='python3 -m IPython'
alias ipy='ipython'
alias iipy='ipython -i'

# diff
alias diffc='diff --color'

# go to tmp directory
alias tmp='cd ~/tmp'

# open without output
open() {
    command open "$@" >/dev/null 2>&1 &disown
}
