# dotfiles

zsh, tmux, neovim, sway/waybar and a set of scripts, managed with GNU Stow.

## Install

```sh
sudo apt-get install -y git
git clone https://github.com/emilel/dotfiles ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` asks what to do, or takes the mode directly:

```sh
./bootstrap.sh terminal          # terminal programs + dotfiles (wsl, servers)
./bootstrap.sh gui               # + sway/waybar/foot/mako/zathura + fonts
./bootstrap.sh dotfiles [pkg..]  # stow only -- all packages, or the ones given
```

There are no other prerequisites: it apt-installs what it can and pulls neovim,
fzf, stylua and lazygit from github releases (apt's are too old). It's
idempotent — re-run it any time. It makes zsh the login shell.

Afterwards: the stowed gitconfig rewrites github https urls to ssh, so put your
ssh keys in `~/.ssh`, then open `nvim` once to let lazy sync and `:Mason`
install language servers.

Machine-specific zsh lives in `~/.setup/*.zsh` (gitignored, sourced at startup).
WSL is detected automatically (skips wayland tools, stows the `clip.exe`
clipboard shim).

## Develop

See `AGENTS.md` for layout and conventions. Tests and formatting:

```sh
just test        # bats suite + neovim plenary
just lint        # zsh -n + shfmt + shellcheck + stylua
just format      # shfmt + stylua
```

## Notes

- **nvidia + sway**:
  `sudo sed -i '/Exec=sway/s/$/ --unsupported-gpu/' /usr/share/wayland-sessions/sway.desktop`.
- **Sample git hooks**: `sample_hooks/`.
