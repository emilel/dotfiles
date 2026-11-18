# AGENTS.md

Dotfiles for zsh, tmux, neovim, sway/waybar and a set of scripts, deployed with
GNU Stow: each top-level dir is a package whose tree mirrors `$HOME`, so
`scripts/.scripts/x.sh` is live as `~/.scripts/x.sh`. Editing a file here edits
the running config.

## Style

Small changes in the existing terse style: short comments that say _why_, no big
functions for simple things, no new abstractions for one caller.

**Keep it from growing.** Prefer removing behaviour over adding a workaround,
and fix the cause rather than layering a fix-up on an earlier fix. Ask before
adding a new script, or when a small gain needs a lot of logic.

- `*.zsh` is sourced into zsh.
- `*.sh` is runnable and `#!/bin/sh` POSIX. Use zsh only where POSIX genuinely
  can't do it, and never bash: the runtime is bash-free. bats is the one bash
  dependency, and only in `tests/`.
- Scripts are named `<domain>_<action>.sh` and are executable.
- Shell is formatted with **shfmt `-i 4 -ci`**, lua with stylua, markdown with
  dprint at 80 columns.

## Where things go

| What                          | Where                                                         |
| ----------------------------- | ------------------------------------------------------------- |
| plain alias                   | `zsh/.config/zsh/commands/aliases.zsh`                        |
| git alias / worktree function | `zsh/.config/zsh/commands/git.zsh`                            |
| alias for a script            | `scripts/.config/zsh/programs/init_aliases.zsh`               |
| shell function                | `zsh/.config/zsh/commands/functions.zsh`                      |
| ZLE widget / zsh keybind      | `zsh/.config/zsh/commands/widgets.zsh`                        |
| zsh completion                | `zsh/.config/zsh/completions/_<cmd>` (autoloaded)             |
| env var / PATH                | `zsh/.config/zsh/settings/{general,path}.zsh`                 |
| script                        | `scripts/.scripts/<domain>_<action>.sh`                       |
| tmux option / binding         | `tmux/.config/tmux/tmux.conf`                                 |
| tmux session template         | `tmux/.tmux_templates/`                                       |
| sway option / binding         | `sway/.config/sway/config`                                    |
| waybar module                 | `waybar/.config/waybar/{config,style.css}` + a script         |
| launcher / rename prompt      | `tofi/.config/tofi/config`, `scripts/.scripts/sway_prompt.sh` |
| Claude Code settings + hooks  | `claude/.claude/settings.json`                                |
| neovim                        | `neovim/.config/nvim` — has its own `AGENTS.md` and tests     |
| machine-specific zsh          | `~/.setup/*.zsh` — outside the repo, never commit it          |

`.zshrc` sources `programs/ settings/ commands/`, then `~/.setup`, then
`plugins.zsh`. `bootstrap.sh` installs programs and runs `stow -R`; a new
top-level package must be added to its package lists.

## Tests

**Anything with a seam gets a bats test, and you run it.** Visual or hardware
behaviour (sway layout, waybar, bluetooth, wifi) can't be auto-tested: put the
logic in a script with a testable mode (e.g. `status`), test that with stubs,
and keep the config change itself small.

```sh
just test     # bats + neovim plenary
just lint     # zsh -n, shfmt, shellcheck, no-bash check, stylua --check
just format   # shfmt + stylua in place
tests/run.sh [unit|scripts|integration|lint|path/to/x.bats]
```

- `tests/scripts/<script>.bats` per script, `tests/unit/` for zsh functions,
  `tests/integration/` for whole-config checks (aliases resolve, configs parse).
- External tools are faked by `tests/helpers/stubs/` (swaymsg, tmux, nmcli, fzf,
  …), put on PATH by `use_stubs`. They log calls and answer from env vars — read
  a stub's header before using it. Add a stub rather than calling the real tool.
- `tests/helpers/fixtures.bash` has `use_stubs`, `mk_git_repo` and
  `assemble_zdotdir`.
- `just lint` picks files by **shebang**, not extension, so extensionless
  scripts (tmux templates, git hooks, stubs) are linted too, and a bash shebang
  outside `tests/` fails.

## Gotchas

- **Live system.** Sway, tmux and waybar are running. `swaymsg reload` is fine;
  don't kill the user's session, tmux server or apps. waybar only reads its
  config at startup and sway won't adopt a bar it didn't spawn, so a waybar
  change needs `pkill waybar; swaymsg reload` — tell the user rather than doing
  it.
- **Sway input identifiers** that match no device are silently ignored. Check
  real ones with `swaymsg -t get_inputs`; one keyboard often shows up as several
  devices, plus a `pointer` with the same identifier.
- **tofi is a layer-shell surface**, not a window: sway `for_window` rules never
  apply to it.
- **tmux 3.4 popups** swallow every key and have no key table; only the shell
  inside exiting (or `display-popup -C`) closes one. tmux also drops bells for
  the window an attached client is viewing.
- **zsh prompt**: pure fills in the git branch from `precmd`, which
  `zle reset-prompt` doesn't re-run, so widgets that change directory accept a
  real `cd` line instead. fzf inside a ZLE widget can only be checked in a real
  terminal.
- **Completions** don't load until `rm $ZSH_COMPDUMP`.
- **Commits** run gitleaks via `hooks/secrets_staged` (bootstrap copies it to
  `.git/hooks/pre-commit`). `secrets/` is gitignored; never add anything from
  it.

## Worktrees

Extra branches live in `.worktrees/<branch-with-slashes-flattened>` inside the
checkout, excluded via `.git/info/exclude`.
`git_worktree.sh <clone|new|add|sync|remove|prune-merged|switch>` does the work
(fetch first, fast-forward only, works from inside a worktree); the wrappers in
`git.zsh` just `cd` into the result.

## Handing off

When a change can't be verified by tests, tell the user exactly what to reload
and check by hand. Rollback is `git checkout <file>` plus that reload.
