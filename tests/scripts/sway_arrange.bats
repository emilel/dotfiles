#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/sway_arrange.sh"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
}

@test "laptop only: 1920x1080 at 0, all workspaces on eDP-1" {
    export SWAY_JSON='[{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output eDP-1 mode 1920x1080 pos 0 0"
    assert_line "workspace 5 output eDP-1"
}

@test "home (4K DP-1 + eDP-1): external forced to 2560x1440 (NOT its 4K max)" {
    export SWAY_JSON='[{"name":"DP-1","active":true,"modes":[{"width":1920,"height":1080},{"width":2560,"height":1440},{"width":3840,"height":2160}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output DP-1 mode 2560x1440 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 pos 2560 0"
    assert_line "workspace 1 output DP-1"
    assert_line "workspace 7 output DP-1"
    assert_line "workspace 4 output eDP-1"
    refute_line --partial "3840x2160"
}

@test "stockholm (HDMI-A-1): different name, same 2560x1440 + order" {
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":2560,"height":1440},{"width":3840,"height":2160}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output HDMI-A-1 mode 2560x1440 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 pos 2560 0"
}

@test "external without 2560x1440 falls back to its native (no mode forced)" {
    export SWAY_JSON='[{"name":"VGA-1","active":true,"modes":[{"width":1920,"height":1080}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output VGA-1 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 pos 1920 0"
}
