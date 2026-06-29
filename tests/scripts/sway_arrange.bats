#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/sway_arrange.sh"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
}

@test "laptop only: native res, scale 1, all workspaces on eDP-1" {
    export SWAY_JSON='[{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 0 0"
    assert_line "workspace 5 output eDP-1"
}

@test "4K external: native 3840x2160 + scale 1.5 (crisp, feels like 2560), laptop right" {
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":2560,"height":1440},{"width":3840,"height":2160}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output HDMI-A-1 mode 3840x2160 scale 1.5 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 2560 0"
    assert_line "workspace 1 output HDMI-A-1"
    assert_line "workspace 4 output eDP-1"
}

@test "1440p external (home): native 2560x1440 + scale 1 (no upscaling needed)" {
    export SWAY_JSON='[{"name":"DP-1","active":true,"modes":[{"width":1920,"height":1080},{"width":2560,"height":1440}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output DP-1 mode 2560x1440 scale 1 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 2560 0"
}
