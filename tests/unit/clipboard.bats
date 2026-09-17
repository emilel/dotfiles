#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    CLIP="$REPO_ROOT/zsh/.config/zsh/commands/clipboard.zsh"
    export XDG_SESSION_TYPE=wayland
    export CLIP_FILE="$BATS_TEST_TMPDIR/clip"
}

@test "copy echoes stdin and writes it to the clipboard" {
    run zsh -c "source '$CLIP'; printf 'hello world' | copy"
    assert_success
    assert_output "hello world"
    assert_equal "$(cat "$CLIP_FILE")" "hello world"
}

@test "copyr resolves to wl-copy under wayland" {
    run zsh -c "source '$CLIP'; alias copyr"
    assert_success
    assert_output --partial "wl-copy"
}

@test "paster resolves to wl-paste under wayland" {
    run zsh -c "source '$CLIP'; alias paster"
    assert_success
    assert_output --partial "wl-paste"
}

@test "copyc prints just the output but copies the command header + output block" {
    run zsh -c "source '$CLIP'; copyc echo hi there"
    assert_success
    assert_output "hi there"
    assert_equal "$(cat "$CLIP_FILE")" "$(printf '> echo hi there\n\nhi there')"
}
