#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/sway_arrange.sh"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
}

@test "laptop only: all workspaces on eDP-1, nothing positioned" {
    export SWAY_JSON='[{"name":"eDP-1","active":true,"current_mode":{"width":1920,"height":1080}}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "workspace 1 output eDP-1"
    assert_line "workspace 5 output eDP-1"
    refute_line --partial "pos"
}

@test "home (DP-1 + eDP-1): external left, laptop right, workspaces pinned" {
    export SWAY_JSON='[{"name":"DP-1","active":true,"current_mode":{"width":2560}},{"name":"eDP-1","active":true,"current_mode":{"width":1920}}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output DP-1 pos 0 0"
    assert_line "output eDP-1 pos 2560 0"
    assert_line "workspace 1 output DP-1"
    assert_line "workspace 7 output DP-1"
    assert_line "workspace 4 output eDP-1"
}

@test "stockholm (HDMI-A-1 + eDP-1): adapts to the different external name" {
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"current_mode":{"width":2560}},{"name":"eDP-1","active":true,"current_mode":{"width":1920}}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output HDMI-A-1 pos 0 0"
    assert_line "output eDP-1 pos 2560 0"
    assert_line "workspace 6 output eDP-1"
}
