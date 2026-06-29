# Repo-wide format / lint / test. Run `just` (or `just --list`) to see recipes.

# show the recipe list
default:
    @just --list

# --- test --------------------------------------------------------------------

# run every test suite (shell config + neovim)
test: test-shell test-nvim

# bats suite for zsh/tmux/scripts
test-shell:
    tests/run.sh

# plenary suite for the neovim config
test-nvim:
    neovim/.config/nvim/tests/run.sh

# --- lint --------------------------------------------------------------------

# lint every shell source + check lua formatting
lint: lint-shell lint-lua

# zsh -n for zsh, shfmt + shellcheck for sh
lint-shell:
    tests/lint.sh

# stylua format check on the neovim lua
lint-lua:
    stylua --check neovim/.config/nvim

# --- format ------------------------------------------------------------------

# format shell (shfmt) and lua (stylua) in place
format: format-shell format-lua

# shfmt every tracked POSIX/bash .sh (zsh files can't be shfmt'd; neovim is self-managed)
format-shell:
    #!/bin/sh
    git ls-files -z '*.sh' | grep -zv '^neovim/' | xargs -0 -r shfmt -i 4 -ci -w
    echo "formatted shell"

# stylua the neovim lua
format-lua:
    stylua neovim/.config/nvim
