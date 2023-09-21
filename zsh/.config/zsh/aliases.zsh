# configuration

## reload zsh configuration

alias reload='source ~/.config/zsh/.zshrc'

## open dotfiles

alias conf='cd ~/dotfiles && nvim . && cd -'

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
