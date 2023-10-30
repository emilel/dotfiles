#!/bin/zsh -f

dir=/usr/share/applications
application=$(ls $dir | grep -Po "^([\w-]+)(?=\.desktop)" | tofi)
file="$dir/$application.desktop"
command=$(grep -Pom1 "Exec=\K.*(?=%u|$)" $file | sed 's/ %u//g')
[[ $(grep -Pom1 "Terminal=\K.*(?=%u|$)" $file) == 'true' ]] && terminal=1 || terminal=0

echo $command >> $HOME/log
echo $terminal >> $HOME/log

if [[ $terminal == 1 ]]; then
    swaymsg "exec foot $command"
else
    swaymsg "exec $command"
fi
