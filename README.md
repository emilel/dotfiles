# use this repo
```console
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

```console
git clone --bare git@github.com:emilel/Dotfiles.git $HOME/.dotfiles
```

```console
dotfiles checkout
```

# programs:
`fd`, `batcat`, `nvim`, `zathura`, `sxiv`, `i3`, `i3blocks`, `nnn`, `ripgrep`,
`i3lock`.

# nvim as git pager
```console
git config --global core.pager "nvim -c '%sm/\\e.\\{-}m//ge' -c 'set ft=diff'
-c 'normal gg' -c 'setlocal buftype=nofile' -c 'set nolist' -"
```
