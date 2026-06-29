#!/bin/sh
# Run the shell-config test suite (bats) and the linter.
#
#   tests/run.sh                 # lint + every bats suite
#   tests/run.sh unit            # one suite: unit | scripts | integration
#   tests/run.sh lint            # linter only
#   tests/run.sh path/to/x.bats  # a single file
#
# bats (+ support/assert) is cloned into tests/.deps on first run, exactly like
# the neovim suite clones plenary. Override the bats binary with $BATS; set
# NO_LINT=1 to skip the linter in the default run.
#
# This runner is POSIX sh on purpose: only the bats binary itself needs bash, so
# linting and suite selection work on a bash-free system.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
deps="$here/.deps"

clone_dep() { # owner/repo  tag  dest
    if [ ! -d "$3" ]; then
        echo "cloning $1@$2"
        git clone --quiet -c advice.detachedHead=false \
            --depth 1 --branch "$2" "https://github.com/$1" "$3"
    fi
}
clone_dep bats-core/bats-core v1.13.0 "$deps/bats-core"
clone_dep bats-core/bats-support v0.3.0 "$deps/bats-support"
clone_dep bats-core/bats-assert v2.2.4 "$deps/bats-assert"

bats="${BATS:-$deps/bats-core/bin/bats}"
REPO_ROOT=$(cd "$here/.." && pwd)
export REPO_ROOT
export BATS_LIB_PATH="$deps"
export STUBS="$here/helpers/stubs"

run_suite() { "$bats" --print-output-on-failure --recursive "$here/$1"; }

target="${1:-all}"
case "$target" in
    lint) "$here/lint.sh" ;;
    unit | scripts | integration) run_suite "$target" ;;
    all)
        [ "${NO_LINT:-0}" = 1 ] || "$here/lint.sh"
        run_suite unit
        run_suite scripts
        run_suite integration
        ;;
    *) "$bats" --print-output-on-failure "$target" ;;
esac
