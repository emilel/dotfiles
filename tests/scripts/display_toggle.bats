#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    D="$REPO_ROOT/scripts/.scripts/display_toggle.sh"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
    export XDG_RUNTIME_DIR="$BATS_TEST_TMPDIR"
    PREF="$XDG_RUNTIME_DIR/sway_ext_mode"
}

@test "status: hidden (empty) when no external is connected" {
    export SWAY_JSON='[{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$D" status
    assert_success
    assert_output ""
}

@test "status: hidden when the external runs its native res at >=50Hz (no tradeoff)" {
    export SWAY_JSON='[{"name":"DP-1","active":true,"modes":[{"width":2560,"height":1440,"refresh":59951}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$D" status
    assert_success
    assert_output ""
}

@test "status: shows 60Hz by default when a 4K external forces the tradeoff" {
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":2560,"height":1440,"refresh":59951},{"width":3840,"height":2160,"refresh":30000}]},{"name":"eDP-1","active":true,"modes":[{"width":1920,"height":1080,"refresh":60000}]}]'
    run sh "$D" status
    assert_success
    assert_output "60Hz"
}

@test "status: shows 4K when the preference is crisp" {
    printf crisp >"$PREF"
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":2560,"height":1440,"refresh":59951},{"width":3840,"height":2160,"refresh":30000}]}]'
    run sh "$D" status
    assert_success
    assert_output "4K"
}

@test "toggle: flips smooth -> crisp and re-runs the arrange" {
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":3840,"height":2160,"refresh":30000}]}]'
    run sh "$D"
    assert_success
    run cat "$PREF"
    assert_output "crisp"
    run cat "$SWAY_LOG" # exec'd sway_arrange.sh actually applied a mode
    assert_line "output HDMI-A-1 mode 3840x2160 scale 1.5 pos 0 0"
}

@test "toggle: flips crisp -> smooth" {
    printf crisp >"$PREF"
    export SWAY_JSON='[{"name":"HDMI-A-1","active":true,"modes":[{"width":3840,"height":2160,"refresh":30000}]}]'
    run sh "$D"
    assert_success
    run cat "$PREF"
    assert_output "smooth"
}
