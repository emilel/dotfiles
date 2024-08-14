# configuration

## reload zsh configuration

alias reload='source ~/.config/zsh/.zshrc'

## open dotfiles

alias conf='cd ~/dotfiles && nvim +OpenFile && cd -'

# quick ones

## go up a folder

alias up='cd ..'

## go back

alias back='cd -'

## send bell

alias bell='echo -e "\a"'

# programs

## write temporary markdown

alias tempmd='nvim +TempMD'

## python in a hurry

alias py='ipython'

## start shell

alias psh='poetry shell'

## find ip address

alias whatsmyip='curl ifconfig.io'
