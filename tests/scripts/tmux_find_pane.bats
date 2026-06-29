#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/tmux_find_pane.sh"
}

@test "prints the pane id whose @label matches" {
    export TMUX_LIST='%1 editor
%2 shell
%3 logs'
    run sh "$S" shell
    assert_success
    assert_output "%2"
}

@test "exits non-zero when no pane carries the label" {
    export TMUX_LIST='%1 editor'
    run sh "$S" nope
    assert_failure
}
