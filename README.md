# dotfiles

zsh, tmux, neovim, sway/waybar and a set of scripts, managed with GNU Stow.

## Install

Prerequisites: `git`, `stow`, `zsh`, `neovim`, `nnn`, `ripgrep`, `fd`, `fzf`,
`jq`, and your ssh keys in `~/.ssh`.

```sh
git clone https://github.com/emilel/dotfiles ~/dotfiles
cd ~/dotfiles
./bootstrap.sh          # stow everything, clone zsh plugins, fix up the env
chsh -s "$(which zsh)"  # make zsh the login shell
```

`bootstrap.sh` is idempotent — re-run it any time. Open `nvim` once to let lazy
sync and `:Mason` install language servers.

Machine-specific zsh lives in `~/.setup/*.zsh` (gitignored, sourced at startup).

## Develop

See `AGENTS.md` for layout and conventions. Tests and formatting:

```sh
just test        # bats suite + neovim plenary
just lint        # zsh -n + shfmt + shellcheck + stylua
just format      # shfmt + stylua
```

## Notes

- **GUI**: install `sway`, `foot`, `waybar`, `mako`, `wl-clipboard`, `bemenu`,
  `grim`, `slurp`, then `bootstrap.sh` stows the configs. Wifi via `nmtui`,
  bluetooth via the waybar widget (`bluetoothctl` / optional `bluetuith`).
- **Font**: `zsh font/install_source_code_pro.zsh`.
- **nvidia + sway**: `sudo sed -i '/Exec=sway/s/$/ --unsupported-gpu/' /usr/share/wayland-sessions/sway.desktop`.
- **Sample git hooks**: `sample_hooks/`.
