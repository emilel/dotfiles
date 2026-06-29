# Common bats preamble: assertion libraries + shared fixtures.
# Every spec starts with `load ../helpers/load`.
# shellcheck shell=bash
bats_require_minimum_version 1.5.0
bats_load_library bats-support
bats_load_library bats-assert

_HELPERS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
. "${_HELPERS_DIR}/fixtures.bash"
