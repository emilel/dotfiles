#!/usr/bin/env bash
# Run the Neovim config test suite (unit + behavior) headlessly via plenary.
#
#   tests/run.sh              # run everything
#   tests/run.sh lib          # run only tests/lib
#   tests/run.sh behavior     # run only tests/behavior
#
# Override the Neovim binary with $NVIM and plenary location with $PLENARY_PATH.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
nvim="${NVIM:-nvim}"
target="${1:-}"

# Ensure plenary is available; clone a shallow copy if we can't find one.
deps="$here/.deps"
plenary="${PLENARY_PATH:-}"
if [[ -z "$plenary" || ! -d "$plenary" ]]; then
	for c in "$HOME/.local/share/nvim/lazy/plenary.nvim" "$deps/plenary.nvim"; do
		[[ -d "$c" ]] && plenary="$c" && break
	done
fi
if [[ -z "$plenary" || ! -d "$plenary" ]]; then
	echo "plenary not found; cloning into $deps/plenary.nvim"
	mkdir -p "$deps"
	git clone --depth=1 https://github.com/nvim-lua/plenary.nvim "$deps/plenary.nvim"
	plenary="$deps/plenary.nvim"
fi
export PLENARY_PATH="$plenary"

dir="$here/${target}"
echo "Running specs in: $dir"
"$nvim" --headless -u "$here/minimal_init.lua" \
	-c "PlenaryBustedDirectory $dir { minimal_init = '$here/minimal_init.lua' }"
