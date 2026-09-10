#!/bin/sh
# Lint every shell source in the repo, dialect-aware:
#   *.zsh / *.zshrc / *.zshenv     -> `zsh -n`   (shfmt & shellcheck can't parse zsh)
#   a sh/bash shebang              -> shfmt + shellcheck
#   a zsh shebang                  -> `zsh -n`
#
# Picked by shebang, not by name: the tmux templates, the git hooks and the test
# stubs are all shell with no extension, and while this walked `*.sh` alone they
# were the files where the rules did not apply -- a bash shebang sat in
# .tmux_templates/notes, against the whole point of a bash-free runtime, for as
# long as it took to look.
#
# Missing shfmt/shellcheck are reported once and skipped, never fatal.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT="${REPO_ROOT:-$(cd "$here/.." && pwd)}"
cd "$REPO_ROOT"

have() { command -v "$1" >/dev/null 2>&1; }
have shfmt || echo "lint: shfmt not found — skipping format checks"
have shellcheck || echo "lint: shellcheck not found — skipping (bootstrap installs it)"

lint_zsh() {
    zsh -n "$1" && return 0
    echo "FAIL zsh -n: $1"
    return 1
}

# The runtime is bash-free on purpose (AGENTS.md's dialect rule): bats is the one
# bash dependency and it is test-only. shellcheck is happy either way, so this is
# the only thing that says so.
lint_no_bash() {
    case "$1" in
        tests/* | */tests/*) return 0 ;;
    esac
    case "$(head -n1 "$1")" in
        *bash*)
            echo "FAIL bash shebang: $1 — the runtime is POSIX sh only"
            return 1
            ;;
    esac
}

lint_posix() {
    rc=0
    lint_no_bash "$1" || rc=1
    if have shfmt; then
        if ! diff=$(shfmt -i 4 -ci -d "$1" 2>&1) || [ -n "$diff" ]; then
            echo "FAIL shfmt: $1"
            printf '%s\n' "$diff"
            rc=1
        fi
    fi
    if have shellcheck; then
        shellcheck -x "$1" || rc=1
    fi
    return "$rc"
}

fail=0
IFS='
'
# shellcheck disable=SC2046  # git ls-files output is newline-split on purpose
for f in $(git ls-files); do
    case "$f" in
        tests/.deps/* | neovim/*) continue ;; # neovim is a self-managed package
        *.zsh | *.zshrc | *.zshenv) lint_zsh "$f" || fail=1 ;;
        *)
            [ -f "$f" ] || continue # a submodule or a symlink to nowhere
            case "$(head -n1 "$f")" in
                '#!'*zsh*) lint_zsh "$f" || fail=1 ;;
                '#!'*sh*) lint_posix "$f" || fail=1 ;;
            esac
            ;;
    esac
done
unset IFS

[ "$fail" = 0 ] && echo "lint: ok"
exit "$fail"
