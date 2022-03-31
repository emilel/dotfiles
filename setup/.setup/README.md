# Setup

## Hardware

Go to `~/.setup` and edit the configuration files.

### bt\_devices

These are bluetooth device mac addresses, which can be used with `btconnect`
and `btdisconnect` scripts in `~/.scripts`.

### ifname

Name of the wifi card. Can be found by executing:

```
ip a | grep '[1-9]*:\ .*:' | awk -F : '{ print $2 }'
```

Wifi card is one that is not `lo`, for example `wlan0`.

### sound\_devices

Audio sinks. Can be found by executing:

```
pactl list | grep -A2 -B0 'Sink #'
```

## Software

Programs which might be nice to have:

`acpi arandr bat dmenu fd feh flameshot fzf git i3-wm i3blocks i3lock
imagemagick iw jq man mimeo mutt neovim nnn pandoc playerctl python qutebrowser
ripgrep spotify-tui spotifyd stow sudo sxiv texlive-most tmux xclip xrandr
zathura zathura-pdf-mupdf zsh`

Install the ones you want however they are installed in your distro. Below are
how to setup some of the programs by running commands, but beware: don't
download software you don't recognize. It is better to find current
installation instructions.

Warning: `imagemagick` caused problems on Arch, after locking the computer with
`~/.scripts/pixelate` and waking it up. The problem persisted after a restart,
and was most easily solved by uninstalling `imagemagick`. After reinstalling,
it seems to be alright.

### nvim

Install Plug by running:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Install the plugins in `~/.vimrc` by opening `nvim` and typing `:PlugUpdate`
and pressing Enter. The alias `view` runs the same instance of `nvim` but
uses `~/.vimrc.view` instead, which uses only a subset of the plugins and
settings for read-only files. `view` can therefore be used as a fast pager,
with the same look and feel like `nvim`.

Install a parser for your weapon of choice by opening `nvim` and executing:
`:TSInstall <language>`.

Install debugger for your language by executing in `nvim`: `:Vimspector Install
<debugger>`.

### tmux

Install Tmux Plugin Manager by running:

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### i3

Find your monitors with `xrandr | grep ' connected'`. Find what you have to
edit in `~/.config/i3/.config/i3/config` by searching for `setup`. The lines
with `workspace n output abc` need to be correct with your monitor setup.

Recreate the `n.sh` scripts in `~/.screenlayout` by using `arandr`.

### zsh

Install Powerlevel0k by running:

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ~/.zsh/plugins/powerlevel10k
```

Install zsh-system-clipboard by running:

```
git clone https://github.com/kutsan/zsh-system-clipboard \
    ~/.zsh/plugins/zsh-system-clipboard
```

Install syntax highlighting by running:

```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    ~/.zsh/plugins/zsh-syntax-highlighting
```

Install vi-mode by running:

```
mkdir ~/.zsh/plugins/vi-mode
curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/vi-mode/vi-mode.plugin.zsh > ~/.zsh/plugins/vi-mode/vi-mode.plugin.zsh
```

Install auto suggestions by running:
```
git clone https://github.com/zsh-users/zsh-autosuggestions \
    ~/.zsh/plugins/zsh-autosuggestions
```

### nnn

Install plugins by running:

```
curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
```

Set PAGER in ~/.config/nnn/plugins.
