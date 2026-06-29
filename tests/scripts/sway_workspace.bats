#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
    GOTO="$REPO_ROOT/scripts/.scripts/sway_goto_workspace.sh"
    RENAME="$REPO_ROOT/scripts/.scripts/sway_rename_workspace.sh"
}

@test "goto switches to the workspace whose name contains the query" {
    export SWAY_JSON='[{"name":"1:web"},{"name":"2:slack"}]'
    run sh "$GOTO" slack
    assert_success
    run cat "$SWAY_LOG"
    assert_output --partial "workspace 2:slack"
}

@test "goto fails when nothing matches" {
    export SWAY_JSON='[{"name":"1:web"}]'
    run sh "$GOTO" nope
    assert_failure
}

@test "rename keeps the focused number and appends the given name" {
    export SWAY_PRETTY="Workspace 3 (focused)"
    run sh "$RENAME" myname
    assert_success
    run cat "$SWAY_LOG"
    assert_output --partial "rename workspace to 3:myname"
}

@test "rename falls back to just the number for an empty name" {
    export SWAY_PRETTY="Workspace 5 (focused)"
    run sh "$RENAME" ""
    assert_success
    run cat "$SWAY_LOG"
    assert_output --partial "rename workspace to 5"
}
