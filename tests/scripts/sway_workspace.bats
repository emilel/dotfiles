#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"
    ln -s "$REPO_ROOT/scripts/.scripts" "$HOME/.scripts"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
    export TOFI_LOG="$BATS_TEST_TMPDIR/tofi_log"
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

@test "rename -p takes the name from the fullscreen prompt" {
    export SWAY_PRETTY="Workspace 2 (focused)"
    export SWAY_WORKSPACES='[{"name":"1:web"},{"name":"2"}]'
    export TOFI_PICK=mail
    run sh "$RENAME" -p </dev/null
    assert_success
    run cat "$SWAY_LOG"
    assert_output --partial "rename workspace to 2:mail"
}

@test "rename -p is a bare prompt: nothing to pick from, just what you type" {
    export SWAY_PRETTY="Workspace 2 (focused)"
    export SWAY_WORKSPACES='[{"name":"1:web"},{"name":"9:mail"}]'
    export TOFI_ITEMS_LOG="$BATS_TEST_TMPDIR/items"
    export TOFI_PICK=mail
    run sh "$RENAME" -p </dev/null
    assert_success
    [ ! -s "$BATS_TEST_TMPDIR/items" ]
}

@test "rename -p leaves the workspace alone when escape closes the prompt" {
    export SWAY_PRETTY="Workspace 2 (focused)"
    export SWAY_WORKSPACES='[{"name":"2"}]'
    export TOFI_STATUS=1
    run sh "$RENAME" -p </dev/null
    assert_success
    refute_output --partial rename
    run cat "$SWAY_LOG"
    refute_output --partial "rename workspace"
}
