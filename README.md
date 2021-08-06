# use this repo
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare git@github.com:emilel/Dotfiles.git $HOME/.dotfiles
dotfiles checkout

# programs:
fd batcat nvim zathura sxiv i3 i3blocks nnn ripgrep

# nvim as git pager
git config --global core.pager "nvim -c '%sm/\\e.\\{-}m//ge' -c 'set ft=diff' -c 'normal gg' -c 'setlocal buftype=nofile' -c 'set nolist' -"
