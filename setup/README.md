* install `git`, `stow`, `neovim`, `zsh`, `nnn` and `gcc`

* set up configuration folders

  ```
  git clone http://github.com/emilel/dotfiles ~/dotfiles
  cd ~/dotfiles
  stow neovim zsh nnn scripts
  ```

* start `nvim` and install language servers using `:Mason` and tree sitter
  language support with `:TSInstall <language>`

* set up git:

  ```
  cd ~/dotfiles
  stow git
  ```

* set `zsh` up:

  ```
  chsh -s $(which zsh)
  ```

* set up passwordless sudo if you're a daredevil:

  ```
  sudo visudo
  ```

  append `<username> ALL=(ALL) NOPASSWD:ALL`

* install other nice programs and `stow` possible configurations: `tmux`,
  `fd`/`fd-find`, `ripgrep`, `tree`

* for gui:

  * install `sway`, `foot`, `bemenu` and `wl-clipboard`

  * set up sway configuration

    ```
    cd ~/dotfiles
    stow sway
    ```

  * install adobe source code pro

    ```
    zsh ~/dotfiles/font/install_source_code_pro.zsh
    ```

  * if using nvidia:

    ```
    sudo sed -i '/Exec=sway/s/$/ --unsupported-gpu/' /usr/share/wayland-sessions/sway.desktop
    ```
