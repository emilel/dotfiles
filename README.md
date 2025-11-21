- copy private and public ssh keys to ~/.ssh

- install `git`, `stow`, `nnn`, `gcc`, `ripgrep` and `fd`/`fd-find`.

- set up configuration folders

  ```
  git clone https://github.com/emilel/dotfiles ~/dotfiles
  cd ~/dotfiles
  stow zsh nnn neovim scripts
  ```

- install `neovim`

  ```
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update && sudo apt install neovim -y
  ```

  start `nvim` and install language servers using `:Mason`, treesitter language
  support with `:TSInstall <language>` and github copilot with `:Copilot`

  nice language servers: `beautysh`, `lua-language-server`, `mypy`, `prettier`,
  `pylint`, `pyrefly`, `ruff`, `basedpyright`, `sqruff`, `stylua`.

- set up git

  ```
  cd ~/dotfiles
  stow git
  ```

- install `zsh`

  change shell to `zsh`:

  ```
  chsh -s $(which zsh)
  ```

- sample configuration for `dotfiles` repo:

```
[core]
	repositoryformatversion = 0
	filemode = true
	bare = false
	logallrefupdates = true
	sshCommand = ssh -i ~/.ssh/id_private
[remote "origin"]
	url = git@github.com:emilel/dotfiles.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
[user]
	email = limeliasson@gmail.com
	name = Emil Eliasson
[pull]
	rebase = true
```

- add `fd` command on ubuntu:

  ```sh
  ln -s /usr/bin/fdfind ~/.local/bin/fd
  ```

- to install `fzf`:

  ```sh
  mkdir ~/.install
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.install/fzf
  ~/.install/fzf/install
  sudo ln -s ~/.install/fzf/bin/fzf /usr/local/bin
  sudo ln -s ~/.install/fzf/bin/fzf-tmux /usr/local/bin
  ```

- set up passwordless sudo if you're a daredevil:

  ```
  sudo visudo
  ```

  append `<username> ALL=(ALL) NOPASSWD:ALL`

- install `git jump`:

  ```sh
  wget -O git-jump https://raw.githubusercontent.com/git/git/master/contrib/git-jump/git-jump
  chmod +x git-jump
  sudo mv git-jump /usr/local/bin/
  ```

- store computer specific zsh files in ~/.setup which will be sourced on startup

- for gui:
  - install `sway`, `foot`, `bemenu`, `wl-clipboard`, `waybar`, `blueman`,
    `pavucontrol`

  - set up gui configuration

    ```
    cd ~/dotfiles
    stow sway waybar foot
    ```

  - install adobe source code pro

    ```sh
    zsh ~/dotfiles/font/install_source_code_pro.zsh
    ```

  - if using nvidia:

    ```sh
    sudo sed -i '/Exec=sway/s/$/ --unsupported-gpu/' /usr/share/wayland-sessions/sway.desktop
    ```
