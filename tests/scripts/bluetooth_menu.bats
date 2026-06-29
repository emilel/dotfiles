#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/bluetooth_menu.sh"
    export BT_LOG="$BATS_TEST_TMPDIR/log"
    export BT_DEVICES="Device AA:BB:CC:DD:EE:FF Headphones"
}

@test "connects a disconnected device" {
    export BT_INFO="Connected: no"
    run sh "$S"
    assert_success
    run cat "$BT_LOG"
    assert_output --partial "connect AA:BB:CC:DD:EE:FF"
}

@test "disconnects a connected device" {
    export BT_INFO="Connected: yes"
    run sh "$S"
    assert_success
    run cat "$BT_LOG"
    assert_output --partial "disconnect AA:BB:CC:DD:EE:FF"
}
