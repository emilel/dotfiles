#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/tmux_new_session.sh"
    export TMUX_LOG="$BATS_TEST_TMPDIR/log"
}

@test "creates 'one' when no pooled session exists" {
    export TMUX_SESSIONS=""
    run sh "$S"
    assert_success
    run cat "$TMUX_LOG"
    assert_output --partial "new-session -s one"
}

@test "creates the first free name when some exist" {
    export TMUX_SESSIONS="one two"
    run sh "$S"
    assert_success
    run cat "$TMUX_LOG"
    assert_output --partial "new-session -s three"
    refute_line --partial "new-session -s one"
}
