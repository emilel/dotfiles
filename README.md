alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare git@github.com:emilel/Dotfiles.git $HOME/.cfg
dotfiles checkout

programs:
fd batcat nvim zathura sxiv i3 i3blocks nnn
