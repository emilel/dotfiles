# Shared test fixtures. Sourced via helpers/load.bash.
# shellcheck shell=bash

# Put the stub executables (fake tmux/fzf/swaymsg/wl-copy) ahead of the real
# ones on PATH for the current test.
use_stubs() {
    chmod +x "$STUBS"/* 2>/dev/null || true
    PATH="$STUBS:$PATH"
}

# mk_git_repo <dir> [--bare-able]
# Create a throwaway git repo with one commit and a deterministic identity.
mk_git_repo() {
    local dir="$1"
    mkdir -p "$dir"
    git -C "$dir" init -q -b main
    git -C "$dir" config user.email test@example.com
    git -C "$dir" config user.name test
    git -C "$dir" commit -q --allow-empty -m init
}

# assemble_zdotdir <dest>
# Reconstruct what `stow zsh <pkgs>` produces under ~/.config/zsh: the zsh
# package's own tree plus every package's programs/*.zsh hook, with plugin
# loading neutralised (no network, no external clones).
assemble_zdotdir() {
    local dest="$1" f
    mkdir -p "$dest"
    cp -a "$REPO_ROOT/zsh/.config/zsh/." "$dest/"
    mkdir -p "$dest/programs"
    for f in "$REPO_ROOT"/*/.config/zsh/programs/*.zsh; do
        [ -e "$f" ] || continue
        cp -a "$f" "$dest/programs/"
    done
    : >"$dest/plugins.zsh"
}
