* copy private and public ssh keys to ~/.ssh

* install `git`, `stow`, `nnn` and `gcc`

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

* set up passwordless sudo if you're a daredevil:

  ```
  sudo visudo
  ```

  append `<username> ALL=(ALL) NOPASSWD:ALL`

* for gui:

  * install `sway`, `foot`, `bemenu`, `wl-clipboard`, `waybar`, `blueman`,
    `pavucontrol`

  * set up gui configuration

    ```
    cd ~/dotfiles
    stow sway waybar foot
    ```

  * install adobe source code pro

    ```
    zsh ~/dotfiles/font/install_source_code_pro.zsh
    ```

  * if using nvidia:

    ```
    sudo sed -i '/Exec=sway/s/$/ --unsupported-gpu/' /usr/share/wayland-sessions/sway.desktop
    ```

* install other nice programs and `stow` possible configurations: `tmux`,
  `fd`/`fd-find`, `ripgrep`, `tree`, `bat`, `brightnessctl`

  * if ubuntu, create symlinks to `batcat` and `find`:

    ```
    sudo ln -s /usr/bin/batcat /usr/local/bin/bat
    sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
    ```

  * to install `fzf`:

    ```
    mkdir ~/.install
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.install/fzf
    ~/.install/fzf/install
    sudo ln -s ~/.install/fzf/bin/fzf /usr/local/bin
    ```

* store computer specific zsh files in ~/.setup which will be sourced on startup
