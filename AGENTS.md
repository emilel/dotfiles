# AGENTS.md

Dotfiles for zsh, tmux, neovim, sway/waybar and a pile of scripts. GNU Stow: each
top-level dir is a package whose tree mirrors `$HOME`. Keep changes small and in
the existing terse style — lazy senior, no big functions for simple things.

## The rule that matters

**Write tests and verify, or don't touch it hard enough to break.** Anything with
a seam gets a bats test (`tests/`). Anything visual or hardware — sway layout,
waybar, bluetooth, wifi — can't be auto-tested: make the change conservative,
keep the *logic* tested with stubs, and leave a manual checklist (bottom).

## Dialect

- `*.zsh` — sourced into zsh.
- `*.sh` — runnable, `#!/bin/sh` POSIX (zsh only where POSIX genuinely can't;
  never bash, so the runtime stays bash-free). bats is the one bash dep, test-only.

## Layout

| Dir | What |
|-----|------|
| `zsh/` | `.zshenv` + `.config/zsh`. `.zshrc` sources `programs/ settings/ commands/`, then `~/.setup`, then `plugins.zsh`. `M-r` popup uses `exit/`. |
| `scripts/` | `~/.scripts` (on PATH). POSIX `.sh`, named `<domain>_<action>.sh`. |
| `tmux/` | `tmux.conf` + `.tmux_templates`. |
| `sway/ waybar/ foot/ mako/ zathura/` | GUI configs — folded symlinks, so editing = live on reload. |
| `neovim/` | self-managed lua config with its own `tests/`. |
| `tests/` | bats suite + `lint.sh` for all shell. |
| `dprint/` | `~/.config/dprint` markdown formatter config. |
| `claude/` | `~/.claude/settings.json` — Claude Code settings + hooks (tmux bell colors). |

## Where things go

| What | Where |
|------|-------|
| plain alias | `zsh/.config/zsh/commands/aliases.zsh` |
| git alias / worktree fn | `zsh/.config/zsh/commands/git.zsh` |
| script alias (t, ta, …) | `scripts/.config/zsh/programs/init_aliases.zsh` |
| shell function | `zsh/.config/zsh/commands/functions.zsh` |
| ZLE widget / keybind | `zsh/.config/zsh/commands/widgets.zsh` |
| env var / PATH | `zsh/.config/zsh/settings/{general,path}.zsh` |
| a new script | `scripts/.scripts/<domain>_<action>.sh` |
| tmux binding | `tmux/.config/tmux/tmux.conf` |
| sway binding | `sway/.config/sway/config` |
| editor formatter | `neovim/.config/nvim/lua/plugins/conform.lua` |
| machine-specific zsh | `~/.setup/*.zsh` (gitignored, sourced at startup) |

## Test / lint / format

```sh
just test        # bats (tests/) + neovim plenary
just lint        # zsh -n + shfmt + shellcheck; stylua --check
just format      # shfmt + stylua
tests/run.sh [unit|scripts|integration|lint]
```

Shell formatter is **shfmt** `-i 4 -ci` (editor + lint + justfile all agree).
Markdown is **dprint** at 80. Stub external tools in `tests/helpers/stubs/`; see
`fixtures.bash` for `mk_git_repo` / `assemble_zdotdir`.

## Worktrees

Bare repo + sibling worktrees. `git_worktree.sh <clone|new|add|sync|remove|
prune-merged|switch>` does the work — fetch-first, fast-forward-only, dirs mirror
branch names. `gct gwn gwa gws gw gwrm gwr.` are thin zsh wrappers that `cd` in.

## Bootstrap

`./bootstrap.sh` — idempotent: prune dead symlinks, relocate the compdump to
`~/.cache`, create `~/.setup`, clone plugins, install test/format tools,
`stow -R`. Re-runnable. Reload after: tmux `M-R`, `swaymsg reload`.

## Manual checklist (what tests can't cover)

After `swaymsg reload`:

- **monitors**: external left, laptop right; ws 1-3 + 7-9 on external, 4-6 + 10
  on laptop; `$mod+Shift+m` re-arranges after plug/unplug.
- **waybar**: shows `BT 0` when nothing's connected; bluetooth left-click = fzf
  known devices, right-click = `bluetuith` (pair new); network left-click = wifi
  fzf, right-click = `nmtui`.
- **`M-r`** tmux popup runs one command then exits.

Rollback any config: `git checkout <file> && swaymsg reload` — nothing is pushed.
