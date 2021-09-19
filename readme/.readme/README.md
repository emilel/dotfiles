# Setup

## Vim

### Install Plug

Visit [github](https://github.com/junegunn/vim-plug) for instructions, or run:

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### Don't leak anything secret

Check permissions for `~/.vim/undo`.

## Tmux

### Install Tmux Plugin Manager

Run:

```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Don't leak anything secret

Check permissions for `~/.tmux/resurrect`.

## i3

Edit the `workspace n output abc` lines in `~/.config/i3/.config/i3/config`.
Find the output devices with `xrandr | grep ' connected'`.

# Install Powerlevel10k

Run:

```
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ~/.zsh/plugins/powerlevel10k
```

# Install zsh-system-clipboard

Run:

```
git clone https://github.com/kutsan/zsh-system-clipboard \
    ~/.zsh/plugins/zsh-system-clipboard
```
