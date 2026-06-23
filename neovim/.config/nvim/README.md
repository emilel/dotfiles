# Neovim config

A small, lazy-loaded config. Everything has one obvious home, so adding a
mapping, setting, command or plugin is a one-file change.

## Layout

```
init.lua                 entry point: load order only
lua/
  config/lazy.lua        bootstraps lazy.nvim, sets <leader>, loads plugins/
  core/                  non-plugin runtime config (loaded in order by core/init.lua)
    options.lua            all vim.opt settings (incl. folding)
    autocmds.lua           autocommands + one-off highlights
    filetypes.lua          filetype detection rules
    commands.lua           user commands (:Clip, :TempFile, :Pipe)
  keymaps/               global, non-plugin keymaps, grouped by theme
    files.lua  windows.lua  navigation.lua  editing.lua  search.lua  yank.lua
  lib/                   pure, unit-testable helpers (no side effects on require)
    strings.lua  paths.lua  search.lua  replace.lua  scratch.lua  pickers.lua
  globals.lua            shared constants (formatoptions, conceallevel)
  plugins/               one file per plugin, spec only
after/ftplugin/          per-filetype settings and buffer-local maps
queries/                 treesitter query overrides
tests/                   headless test suite (see below)
```

Load order (`init.lua`): `config.lazy` → `core` → `keymaps`. The leader is set
in `config/lazy.lua` before anything else.

## Where do I add…

| I want to add a…              | Put it in…                                              |
| ----------------------------- | ------------------------------------------------------- |
| global keymap                 | `lua/keymaps/<theme>.lua` (pick the closest theme)      |
| filetype-specific keymap      | `after/ftplugin/<ft>.lua`                               |
| option (`vim.opt.…`)          | `lua/core/options.lua`                                  |
| autocommand                   | `lua/core/autocmds.lua`                                 |
| filetype detection rule       | `lua/core/filetypes.lua`                                |
| user command (`:Foo`)         | `lua/core/commands.lua`                                 |
| plugin                        | new file in `lua/plugins/` returning a lazy.nvim spec   |
| plugin keymap                 | the plugin's own spec, in its `keys = { … }`            |
| reusable helper / pure logic  | `lua/lib/` (and a test in `tests/lib/`)                 |

## Lazy loading

Plugins are loaded on demand. When adding one, give it a trigger:

- `event = { "BufReadPre", "BufNewFile" }` — needs a real file (LSP, gitsigns)
- `event = "InsertEnter"` — only while typing (completion, copilot)
- `keys = { … }` / `cmd = "…"` — on first use (pickers, formatters, git)
- `ft = "lua"` — only for a filetype
- `event = "VeryLazy"` — after startup (statusline)
- no trigger — eager; reserve for colorscheme and must-load-early plugins

Avoid `require("<plugin>")` at the top level of a spec — it forces an eager
load. Wrap it in a `function()` inside `keys`/`config` instead.

## Scratch / clipboard buffers

`lua/lib/scratch.lua` powers a few throwaway-buffer commands, each also exposed
as a shell helper (`zsh/.config/zsh/commands/`). In all of them `<cr><cr>`
finishes. Scratch buffers are saved under `/tmp/nvim-scratch/`, named by
creation time, so you can reopen their contents later (cleared on reboot):

| command / key   | shell     | what it does                                        |
| --------------- | --------- | --------------------------------------------------- |
| `:Clip`         | `clip`    | edit the clipboard; `<cr><cr>` writes it back, quits|
| `:TempFile [ft]`| `temp`    | scratch buffer; `<cr><cr>` copies to clipboard, quits|
| `:Pipe <path>`  | `edit`    | edit stdin→stdout; `<cr><cr>` saves and quits       |
| `<space>b`      |           | in-editor scratch; `<cr><cr>` copies and closes     |
| `<space>+`      |           | edit the clipboard in the current filetype          |

## Python virtualenvs

There is no global venv switching (an active `$VIRTUAL_ENV` would shadow a
subproject's own). Instead, both the LSP (`plugins/lsp.lua`) and the linters
(`plugins/lint.lua`) resolve the nearest `.venv` to the *current file* and use
it, so monorepos with several venvs just work.

## Tests

```sh
tests/run.sh            # all specs (plenary, headless)
tests/run.sh lib        # unit tests for lua/lib
tests/run.sh behavior   # real-keystroke integration tests
```

Unit specs live in `tests/lib/`, behaviour specs in `tests/behavior/`. The
behaviour specs drive actual keystrokes and assert on the result.
