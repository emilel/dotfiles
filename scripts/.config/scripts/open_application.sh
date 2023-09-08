#!/bin/zsh -f

dir=/usr/share/applications
application=$(ls $dir | grep -Po "^([\w-]+)(?=\.desktop)" | fzf --no-info --no-scrollbar --no-color --pointer=' ' --layout=reverse)
file="$dir/$application.desktop"
command=$(grep -Pom1 "Exec=\K.*(?=%u|$)" $file | sed 's/ %u//g')
[[ $(grep -Pom1 "Terminal=\K.*(?=%u|$)" $file) == 'true' ]] && terminal=1 || terminal=0

if [[ $terminal == 1 ]]; then
    swaymsg "exec foot $command"
else
    swaymsg "exec $command"
fi
