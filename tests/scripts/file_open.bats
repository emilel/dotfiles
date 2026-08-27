#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/file_open.sh"
    export XDG_OPEN_LOG="$BATS_TEST_TMPDIR/xdg.log"
    F="$BATS_TEST_TMPDIR/x.pdf"
    : >"$F"
}

@test "hands the file to the opener" {
    run sh "$S" "$F"
    assert_success
    run cat "$XDG_OPEN_LOG"
    assert_output "$F"
}

@test "a url goes through without an existence check" {
    run sh "$S" https://example.com
    assert_success
    run cat "$XDG_OPEN_LOG"
    assert_output "https://example.com"
}

@test "a missing file is rejected before anything is launched" {
    run sh "$S" "$BATS_TEST_TMPDIR/nope.pdf"
    assert_failure 66
    assert_output --partial "no such file"
    assert [ ! -f "$XDG_OPEN_LOG" ]
}

@test "no arguments prints usage" {
    run sh "$S"
    assert_failure 64
    assert_output --partial "usage:"
}

@test "a launcher that fails shows its message and its status" {
    XDG_OPEN_MODE=fail run sh "$S" "$F"
    assert_failure 3
    assert_output --partial "no method available"
}

@test "an app that stays up returns straight away and is not heard from" {
    local start=$SECONDS
    XDG_OPEN_MODE=linger run sh "$S" "$F"
    assert_success
    assert_output ""
    assert [ $((SECONDS - start)) -lt 4 ]
}
