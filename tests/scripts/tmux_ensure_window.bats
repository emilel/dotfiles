#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/tmux_ensure_window.sh"
    export TMUX_LOG="$BATS_TEST_TMPDIR/log"
    export TMUX_LIST='editor
shell'
}

@test "creates the window when it is absent" {
    run sh "$S" mysess logs
    assert_success
    run cat "$TMUX_LOG"
    assert_output --partial "new-window -d -t mysess -n logs"
}

@test "does nothing when the window already exists" {
    run sh "$S" mysess shell
    assert_success
    run cat "$TMUX_LOG"
    refute_line --partial "new-window"
}
