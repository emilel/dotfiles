* copy private and public ssh keys to ~/.ssh

* install `git`, `stow`, `nnn`, `gcc`, `ripgrep` and `fd`/`fd-find`.

* set up configuration folders

  ```
  git clone https://github.com/emilel/dotfiles ~/dotfiles
  cd ~/dotfiles
  stow zsh nnn neovim scripts
  ```

* install `neovim`

  ```
  sudo add-apt-repository ppa:neovim-ppa/unstable
  sudo apt update
  ```

  start `nvim` and install language servers using `:Mason`, tree sitter language
  support with `:TSInstall <language>` and github copilot with `:Copilot`

  nice language servers: `beautysh`, `isort`, `lua-language-server`,
  `mypy`, `prettierd`, `pylint`, `pyrefly`, `ruff`, `sqruff`, `stylua`.

* set up git

  ```
  cd ~/dotfiles
  stow git
  ```

* install `zsh`

  change shell to `zsh`:

  ```
  chsh -s $(which zsh)
  ```

* sample configuration for `dotfiles` repo:
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
```

* set up passwordless sudo if you're a daredevil:

  ```
  sudo visudo
  ```

  append `<username> ALL=(ALL) NOPASSWD:ALL`

* add `fd` command:

  ```sh
  ln -s /usr/bin/fdfind ~/.local/bin/fd
  ```

* for gui:

  * install `sway`, `foot`, `bemenu`, `wl-clipboard`, `waybar`, `blueman`,
    `pavucontrol`

  * set up gui configuration

    ```
    cd ~/dotfiles
    stow sway waybar foot
    ```

  * install adobe source code pro

    ```sh
    zsh ~/dotfiles/font/install_source_code_pro.zsh
    ```

  * if using nvidia:

    ```sh
    sudo sed -i '/Exec=sway/s/$/ --unsupported-gpu/' /usr/share/wayland-sessions/sway.desktop
    ```

* install other nice programs and `stow` possible configurations: `tmux`,
  `fd`/`fd-find`, `ripgrep`, `tree`, `bat`, `brightnessctl`

  * if ubuntu, create symlinks to `batcat` and `find`:

    ```sh
    sudo ln -s /usr/bin/batcat /usr/local/bin/bat
    sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
    ```

  * to install `fzf`:

    ```sh
    mkdir ~/.install
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.install/fzf
    ~/.install/fzf/install
    sudo ln -s ~/.install/fzf/bin/fzf /usr/local/bin
    sudo ln -s ~/.install/fzf/bin/fzf-tmux /usr/local/bin
    ```

* install `git jump`:

  ```sh
  wget -O git-jump https://raw.githubusercontent.com/git/git/master/contrib/git-jump/git-jump
  chmod +x git-jump
  sudo mv git-jump /usr/local/bin/
  ```

* store computer specific zsh files in ~/.setup which will be sourced on startup

* sample precommit hook:


  ```sh
  #!/bin/sh

  if git diff --cached --name-only | xargs grep -n 'TMP'; then
      echo "Error: Commit contains TMP comment"
      exit 1
  fi

  for file in $(git diff --cached --name-only -- '*.c' '*.h'); do
      clang-format -i "$file"
      git add "$file"
  done

  exit 0
  ```
