#!/bin/sh
# Lint every shell source in the repo, dialect-aware:
#   *.zsh / *.zshrc / *.zshenv     -> `zsh -n`   (shfmt & shellcheck can't parse zsh)
#   *.sh with a sh/bash shebang    -> shfmt + shellcheck
#   *.sh with a zsh shebang        -> `zsh -n`
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

lint_posix() {
    rc=0
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
for f in $(git ls-files '*.zsh' '*.sh' '*.zshrc' '*.zshenv'); do
    case "$f" in
        tests/.deps/* | neovim/*) continue ;; # neovim is a self-managed package
        *.zsh | *.zshrc | *.zshenv) lint_zsh "$f" || fail=1 ;;
        *.sh)
            case "$(head -n1 "$f")" in
                *zsh*) lint_zsh "$f" || fail=1 ;;
                *) lint_posix "$f" || fail=1 ;;
            esac
            ;;
    esac
done
unset IFS

[ "$fail" = 0 ] && echo "lint: ok"
exit "$fail"
