#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/sway_arrange.sh"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
    export XDG_RUNTIME_DIR="$BATS_TEST_TMPDIR" # where the mode preference lives
}

@test "laptop only: native res, scale 1, all workspaces on eDP-1" {
    export SWAY_JSON='[{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 0 0"
    assert_line "workspace 5 output eDP-1"
}

@test "smooth (default): 4K external drops to the 1440p 60Hz mode, scale 1, laptop right" {
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":2560,"height":1440,"refresh":59951},{"width":3840,"height":2160,"refresh":30000}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output HDMI-A-1 mode 2560x1440 scale 1 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 2560 0"
    assert_line "workspace 1 output HDMI-A-1"
    assert_line "workspace 4 output eDP-1"
}

@test "crisp: 4K external runs native 3840x2160 30Hz + scale 1.5 (sharp, lower refresh)" {
    printf crisp >"$XDG_RUNTIME_DIR/sway_ext_mode"
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":2560,"height":1440,"refresh":59951},{"width":3840,"height":2160,"refresh":30000}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output HDMI-A-1 mode 3840x2160 scale 1.5 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 2560 0"
}

@test "1440p external (home): native 2560x1440 60Hz + scale 1 (no upscaling needed)" {
    export SWAY_JSON='[{"name":"DP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000},{"width":2560,"height":1440,"refresh":59951}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$S"
    assert_success
    run cat "$SWAY_LOG"
    assert_line "output DP-1 mode 2560x1440 scale 1 pos 0 0"
    assert_line "output eDP-1 mode 1920x1080 scale 1 pos 2560 0"
}
