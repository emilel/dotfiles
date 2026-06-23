# Neovim config — agent handoff

This document gives a new agent (or a new session) everything it needs to
continue work on the config without reading the full git history.

---

## Directory layout

```
init.lua                    -- 3 lines: boots lazy, core, keymaps
lua/
  config/lazy.lua           -- lazy.nvim bootstrap + spec import
  core/
    init.lua                -- requires the four core modules in order
    options.lua             -- all vim.opt settings (single source of truth)
    autocmds.lua            -- autocommands
    filetypes.lua           -- filetype detection overrides
    commands.lua            -- user commands (:TempFile, :Clip, :Pipe)
  globals.lua               -- shared constants (formatoptions, etc.)
  keymaps/
    init.lua                -- requires all keymap files; no plugin keymaps here
    editing.lua             -- text manipulation: join, delete, select, replace
    files.lua               -- save/close/scratch/buffer navigation
    navigation.lua          -- folds, indent jumps, horizontal scroll
    search.lua              -- *, ?, <space>/, search register helpers
    windows.lua             -- window focus, quickfix list
    yank.lua                -- <space>y* copy-to-clipboard helpers
  lib/
    paths.lua               -- file/path/git helpers (get_file_name, basename…)
    pickers.lua             -- telescope wrappers that live outside telescope.lua
    replace.lua             -- :s command builders (drives R / <space>r / <space>R)
    scratch.lua             -- scratch/pipe buffer logic; see SCRATCH below
    search.lua              -- pure pattern builders (word_pattern, append…)
    strings.lua             -- escape_vim, escape_pcre
  plugins/                  -- one file per plugin; lazy-loaded via the spec
after/ftplugin/             -- filetype-specific settings and keymaps
tests/
  minimal_init.lua          -- headless test init: adds rtp, loads plenary + keymaps
  run.sh                    -- runs all specs via PlenaryBustedDirectory
  behavior/                 -- feedkeys-driven tests (keymaps, not pure functions)
    editing_spec.lua
    paste_spec.lua
    scratch_spec.lua
    yank_spec.lua
  lib/                      -- unit tests for pure lib/* modules
    paths_spec.lua
    replace_spec.lua
    search_spec.lua
    strings_spec.lua
```

---

## Where to add things

| What                      | Where                                |
|---------------------------|--------------------------------------|
| Editor setting            | `lua/core/options.lua`               |
| Autocmd                   | `lua/core/autocmds.lua`              |
| User command              | `lua/core/commands.lua`              |
| General keymap            | `lua/keymaps/<theme>.lua`            |
| Plugin keymap             | inside that plugin's spec in `lua/plugins/` |
| Filetype keymap/setting   | `after/ftplugin/<ft>.lua`            |
| Pure helper               | `lua/lib/<module>.lua`               |
| New plugin                | new file in `lua/plugins/`           |

---

## Lazy-loading conventions

Every plugin should be lazy. The trigger to use:

| Trigger           | When to use                                               |
|-------------------|-----------------------------------------------------------|
| `keys = {...}`    | Plugin only needed when the user presses a key            |
| `cmd = "Cmd"`     | Plugin only needed when a user command is run             |
| `event = "BufReadPre"` | Plugin that needs to be active for buffers (LSP, gitsigns) |
| `ft = {"python"}` | Filetype-specific plugins                                 |
| `VeryLazy`        | Nice-to-have UI plugins with no tight startup dependency  |
| `dependencies`    | Ensures a dep loads first; does NOT force the dep eager   |

**Never** put a bare `require()` call at spec-eval time (the table literal level).
Wrap it in a `function()` or put it inside `config`/`init`. Example of the bug:

```lua
-- WRONG: require fires at startup when lazy reads the spec
keys = { { "<space>S", require("telescope.builtin").lsp_workspace_symbols } }

-- RIGHT: require fires when the key is pressed
keys = { { "<space>S", function() require("telescope.builtin").lsp_workspace_symbols() end } }
```

---

## Scratch / temp buffers

Backed by `/tmp/nvim-scratch/<YYYY-MM-DD_HH-MM-SS>.<ext>`. Files are lost on
reboot, which is the intended lifetime. Browse them with `:e /tmp/nvim-scratch/`.

`lib/scratch.lua` exposes two functions:

- `scratch(opts)` — new file, `<cr><cr>` copies to clipboard, saves, closes.
  - `opts.filetype` — sets ft and picks the file extension
  - `opts.content` — prefills text (e.g. clipboard or current buffer)
  - `opts.close` — ex-command on exit (`"bdelete!"` by default, `"quit!"` for CLI)
- `pipe(path)` — opens an existing file, `<cr><cr>` saves and quits.

Shell commands in `zsh/.config/zsh/commands`:

| Shell command | Maps to                         | Purpose                              |
|---------------|---------------------------------|--------------------------------------|
| `clip`        | `:Clip`                         | Edit clipboard, write back on exit   |
| `temp [ft]`   | `:TempFile [ft]`                | Scratch buffer (markdown by default) |
| `edit`        | stdin → `:Pipe <tmpfile>`       | Stdin/stdout filter through nvim     |

---

## Python / venv handling

The config uses **per-file venv resolution**: for every Python buffer, the
nearest `.venv/` directory is found by walking upward from the file. This is
correct for monorepos where each subproject has its own venv.

- **basedpyright** (LSP) — `root_dir` callback in `lua/plugins/lsp.lua` roots
  the server at the project containing the nearest `.venv`. Its
  `before_init` callback points the interpreter at `.venv/bin/python`.
- **ruff** (LSP) — auto-configured via mason-lspconfig; no special venv logic
  needed because ruff discovers its config from `pyproject.toml` at the root.
- **mypy / pylint** (nvim-lint) — `lua/plugins/lint.lua` finds the nearest
  `.venv` and uses its binaries directly, skipping lint if none exists. Only
  skips files under `tests/` paths.

`mason` is configured with `PATH = "append"` so project venv tools take
priority over mason-installed tools.

---

## mason-lspconfig v2 API (current)

The old `handlers = {}` API is gone. The current pattern:

```lua
vim.lsp.config("*", { capabilities = ... })     -- defaults for all servers
vim.lsp.config("server_name", { ... })          -- overrides for one server
require("mason-lspconfig").setup({ ensure_installed = {...} })
-- mason-lspconfig v2 auto-enables every installed server via vim.lsp.enable()
```

Order matters: `vim.lsp.config()` calls must come before `setup()`.

---

## Tests

Run all tests:
```sh
cd neovim/.config/nvim
./tests/run.sh
```

- `tests/minimal_init.lua` — headless init: adds the config to rtp, finds
  plenary, and calls `require("keymaps")` to register the global keymaps.
- `tests/behavior/` — feedkeys-driven tests that exercise actual keymap
  behaviour. Use `vim.api.nvim_feedkeys(termcodes, "mx", false)` — the `m`
  flag enables remaps (so our remaps fire), `x` flushes the typeahead
  synchronously.
- `tests/lib/` — pure unit tests for `lib/*` helpers.
- Clipboard tests in headless need `fake_clipboard()` (see `scratch_spec.lua`)
  because there is no system clipboard in a headless process.

---

## Known state (as of branch `claude/neovim-config-refactor-m1qhhg`)

This branch is a full refactor of the config from a single 439-line keymap
file into the structure above. Key decisions:

- Scratch buffers persist to timestamped files under `/tmp/nvim-scratch/`.
- `mason PATH = "append"` keeps project venv tools ahead of mason tools.
- `telescope-fzy-native` was removed from telescope's dependencies (it was
  listed but never loaded; being a C extension it could fail to compile and
  silently prevent telescope from loading).
- `ruff` moved from nvim-lint to LSP; nvim-lint still runs mypy and pylint.
- Fold text is empty (`foldtext = ""`), which makes Neovim render the first
  fold line with its real syntax highlighting instead of a washed-out summary.
- `<space>S` (workspace symbols) requires an active LSP session; if nothing
  shows, confirm with `:LspInfo` that basedpyright is attached.

---

## How to test the branch before merging

```sh
git fetch origin
git checkout claude/neovim-config-refactor-m1qhhg
nvim                      # :Lazy sync, then :Mason to install servers
./neovim/.config/nvim/tests/run.sh
```

Merge to master when satisfied.
