# AGENTS.md

Dotfiles for zsh, tmux, neovim, sway/waybar and a pile of scripts. GNU Stow:
each top-level dir is a package whose tree mirrors `$HOME`. Keep changes small
and in the existing terse style — lazy senior, no big functions for simple
things.

## The rule that matters

**Write tests and verify, or don't touch it hard enough to break.** Anything
with a seam gets a bats test (`tests/`). Anything visual or hardware — sway
layout, waybar, bluetooth, wifi — can't be auto-tested: make the change
conservative, keep the _logic_ tested with stubs, and leave a manual checklist
(bottom).

## Dialect

- `*.zsh` — sourced into zsh.
- `*.sh` — runnable, `#!/bin/sh` POSIX (zsh only where POSIX genuinely can't;
  never bash, so the runtime stays bash-free). bats is the one bash dep,
  test-only. `just lint` enforces this: it picks files by **shebang**, so the
  extensionless ones — tmux templates, git hooks, test stubs — are covered too,
  and a bash shebang outside `tests/` fails the run.

## Layout

| Dir                                  | What                                                                                                                                                                                                               |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `zsh/`                               | `.zshenv` + `.config/zsh`. `.zshrc` sources `programs/ settings/ commands/`, then `~/.setup`, then `plugins.zsh`. `exit/` is a ZDOTDIR for the old run-one-command `M-r` popup, kept commented out in `tmux.conf`. |
| `scripts/`                           | `~/.scripts` (on PATH). POSIX `.sh`, named `<domain>_<action>.sh`.                                                                                                                                                 |
| `tmux/`                              | `tmux.conf` + `.tmux_templates`.                                                                                                                                                                                   |
| `sway/ waybar/ foot/ zathura/ mako/` | GUI configs — folded symlinks, so editing = live on reload.                                                                                                                                                        |
| `neovim/`                            | self-managed lua config with its own `tests/`.                                                                                                                                                                     |
| `tests/`                             | bats suite + `lint.sh` for all shell.                                                                                                                                                                              |
| `dprint/`                            | `~/.config/dprint` markdown formatter config.                                                                                                                                                                      |
| `claude/`                            | `~/.claude/settings.json` — Claude Code settings + hooks; both call `claude_notify.sh` (tmux bell colors + a mako popup).                                                                                          |

## Where things go

| What                    | Where                                             |
| ----------------------- | ------------------------------------------------- |
| plain alias             | `zsh/.config/zsh/commands/aliases.zsh`            |
| git alias / worktree fn | `zsh/.config/zsh/commands/git.zsh`                |
| script alias (t, ta, …) | `scripts/.config/zsh/programs/init_aliases.zsh`   |
| shell function          | `zsh/.config/zsh/commands/functions.zsh`          |
| ZLE widget / keybind    | `zsh/.config/zsh/commands/widgets.zsh`            |
| env var / PATH          | `zsh/.config/zsh/settings/{general,path}.zsh`     |
| a new script            | `scripts/.scripts/<domain>_<action>.sh`           |
| tmux binding            | `tmux/.config/tmux/tmux.conf`                     |
| sway binding            | `sway/.config/sway/config`                        |
| editor formatter        | `neovim/.config/nvim/lua/plugins/conform.lua`     |
| machine-specific zsh    | `~/.setup/*.zsh` (gitignored, sourced at startup) |

## Test / lint / format

```sh
just test        # bats (tests/) + neovim plenary
just lint        # zsh -n + shfmt + shellcheck + no-bash; stylua --check
just format      # shfmt + stylua
tests/run.sh [unit|scripts|integration|lint]
```

Shell formatter is **shfmt** `-i 4 -ci` (editor + lint + justfile all agree).
Markdown is **dprint** at 80. Stub external tools in `tests/helpers/stubs/`; see
`fixtures.bash` for `mk_git_repo` / `assemble_zdotdir`.

## Worktrees

A normal clone, extra branches in `.worktrees/<branch-with-slashes-flattened>` —
the layout `~/arbuscular` uses.
`git_worktree.sh <clone|new|add|sync|remove|prune-merged|switch>` does the work
— fetch-first, fast-forward-only, paths hang off the main checkout so it works
from inside a worktree too, and `.worktrees/` goes in `.git/info/exclude`
(local, not a `.gitignore` line committed into someone else's repo).
`gct gwn gwa gws gw gwrm gwr.` are thin zsh wrappers that `cd` in.

## Bootstrap

`./bootstrap.sh` — idempotent: prune dead symlinks, relocate the compdump to
`~/.cache`, create `~/.setup`, clone plugins, install test/format tools,
`stow -R`. Re-runnable. Reload after: tmux `M-R`, `swaymsg reload`.

## Manual checklist (what tests can't cover)

After `swaymsg reload`:

- **monitors**: external left, laptop right; ws 1-3 + 7-9 on external, 4-6 + 10
  on laptop; `$mod+Shift+m` re-arranges after plug/unplug.
- **keyboard layout**: se everywhere except the Go60 and the Kinesis Advantage2,
  which are us (they carry their own layout in firmware). Check with
  `swaymsg -t get_inputs | grep -e identifier -e xkb_active_layout_name`; a
  board matched by an identifier sway has never seen just silently stays se, so
  re-check the identifier after any firmware/name change.
- **waybar**: shows `BT 0` when nothing's connected; bluetooth left-click = fzf
  known devices, right-click = `bluetuith` (pair new); network left-click = wifi
  fzf, right-click = `nmtui`. `KB US` shows only while the Kinesis is plugged
  in; a click or `$mod+s` flips it to `KB SE` (pink) at once and back again,
  and only that board changes.
- **`TB`**: the tmux window colours from any workspace — `TB sess:2 win`, green
  on a bell, red for a claude on a permission prompt (`@claude`). The window on
  screen is never listed. tmux drops bells for the window an attached client
  sits on, so a bell rung _there_ shows up nowhere, not even in tmux — only
  `@claude` (hook-set, focus-blind) covers that window.
- **network**: with eth and wifi both up it names the one carrying the default
  route (lowest metric), and turns red when `nmcli` says that route doesn't
  reach the internet.
- **mako**: `notify-send hi` pops a blue box top-right (mako's own colours) that
  goes away after ten seconds; senders that ask for their own timeout still get
  it. A claude finishing or hitting a permission prompt pops one too, named
  `sess:idx win`, in the same frame as the tmux colour: `claude_notify.sh` rings
  the bell into the pane's own tty and repaints the status line, rather than
  waiting on the bell claude rings for itself — so watch that the two land
  together, not a beat apart. Repeats for one window replace, not stack.
- **`M-r`** tmux popup opens a plain shell in the focused pane's directory and
  stays open; `^D` on an empty line closes it, `^D` mid-line just deletes, and
  `M-r` closes it from any state — a popup swallows every key and tmux 3.4 has
  no popup key table, so nothing but the shell exiting can end one. Once zsh is
  gone the binding's own `display-popup -C` pulls the popup down, so a leftover
  background job holding the popup's tty (`firefox &`) can't keep it on screen
  with no shell behind it. If something wedges past all that, run
  `tmux display-popup -C` from any other terminal.
- **`^H`**: climbs one rung a press — subdir → repo root → the main checkout a
  worktree hangs off → the dir above the repo. It leaves a `cd` line behind and
  draws the next prompt _below_ the old one, branch and all — it accepts a real
  `cd` because pure fills the branch in from precmd, which `reset-prompt` never
  re-runs. The half-typed line comes back after the jump.
- **`^T`**: fzf-picks a worktree by _branch_ (dir names flatten slashes,
  branches don't) and, like `^H`, leaves a `cd` line and a fresh prompt below
  with the new branch on it; the half-typed line comes back. Escaping the picker
  instead puts that line straight back where it was, no `cd` — fzf inside a ZLE
  widget only proves out in a real terminal. Outside a repo it does nothing,
  quietly.
- **treesitter** (after a `bootstrap.sh` on a new machine): open a `.md`, a
  `.sh` and a `.py` — each is coloured, and a fenced `` ```sh `` block inside
  the markdown is coloured as shell. `+` grows the selection a node at a time
  and `-` shrinks it. A filetype with no parser (`justfile`) is plain, not
  broken. Parser compiles are visible as `:TSInstall` progress on first start
  and never again; `:checkhealth nvim-treesitter` is the place to look when a
  language stays uncoloured.
- **`open`**: `open x.pdf` comes straight back to the prompt, and zathura keeps
  running when the terminal — or the `M-r` popup — it was opened from goes away.
  `open nope.pdf` and a file nothing handles print the error; a running app's
  GTK chatter never reaches the prompt. `open https://…` reaches firefox.

waybar only reads its config at startup and sway won't adopt a bar it didn't
spawn: `pkill waybar` before `swaymsg reload`, or you end up with two.

Rollback any config: `git checkout <file> && swaymsg reload` — nothing is
pushed.
