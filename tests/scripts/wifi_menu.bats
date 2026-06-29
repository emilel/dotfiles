#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/wifi_menu.sh"
    export NMCLI_LOG="$BATS_TEST_TMPDIR/log"
}

@test "connects to the fzf-picked network" {
    export WIFI_SSIDS="HomeNet
Cafe
HomeNet"
    run sh "$S"
    assert_success
    run cat "$NMCLI_LOG"
    assert_output --partial "dev wifi connect HomeNet"
}
