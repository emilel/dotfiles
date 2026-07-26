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
./bootstrap.sh gui               # + sway/waybar/foot/zathura + fonts
./bootstrap.sh dotfiles [pkg..]  # stow only -- all packages, or the ones given
```

There are no other prerequisites: it apt-installs what it can and pulls neovim,
fzf and stylua from github releases (apt's are too old). It's idempotent —
re-run it any time. It makes zsh the login shell.

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
- **Git hooks**: `hooks/secrets_staged` (gitleaks) — bootstrap copies it into
  this repo's pre-commit; copy it into any other repo that wants it.
- **Extras** in use on previous machines, not installed by bootstrap (vendor
  repos / heavyweight / machine-specific):
  - `claude`: `curl -fsSL https://claude.ai/install.sh | bash`
  - `uv`: `curl -LsSf https://astral.sh/uv/install.sh | sh`
  - `codex`, `hunkdiff`, `mdpdf`: `npm i -g @openai/codex hunkdiff mdpdf`
  - docker: official apt repo (docs.docker.com/engine/install/ubuntu)
  - `google-chrome-stable` (vendor deb), `slack` (snap), `zoom` (vendor deb)
  - `yt-dlp`, `git-filter-repo`, `mdformat` (uv/pipx)
  - `azure-cli`, `texlive-full`, `valgrind`, `cmake`, `clang-format`, `adb`
  - `ibus-table-cangjie3/5` (chinese input), `bluetuith` (see bootstrap output)
