#!/usr/bin/env bats
# The `edit` filter and its `clip` wrapper: stdin -> nvim -> stdout + clipboard.
load ../helpers/load

setup() {
    use_stubs
    CMDS="$REPO_ROOT/zsh/.config/zsh/commands"
    export XDG_SESSION_TYPE=wayland
    export CLIP_FILE="$BATS_TEST_TMPDIR/clip"
    export NVIM_SAW="$BATS_TEST_TMPDIR/saw"
    export NVIM_LOG="$BATS_TEST_TMPDIR/log"
    # bats has no controlling terminal, so $TTY is empty and the nvim
    # redirects inside `edit` fall back to /dev/null — fine for the stub
}

# clipboard.zsh first: `clip` needs the paster alias at definition time
run_zsh() {
    run zsh -c "source '$CMDS/clipboard.zsh'; source '$CMDS/functions.zsh'; $1"
}

@test "edit prints the edited result and copies it to the clipboard" {
    export NVIM_CONTENT="edited"
    run_zsh "print original | edit"
    assert_success
    assert_output "edited"
    assert_equal "$(cat "$CLIP_FILE")" "edited"
}

@test "edit hands stdin to the editor" {
    run_zsh "print original | edit"
    assert_success
    assert_equal "$(cat "$NVIM_SAW")" "original"
}

@test "edit left alone still prints and copies what came in" {
    run_zsh "print untouched | edit"
    assert_success
    assert_output "untouched"
    assert_equal "$(cat "$CLIP_FILE")" "untouched"
}

@test "edit aborted with :cq prints nothing and leaves the clipboard alone" {
    export NVIM_STATUS=1
    run_zsh "print original | edit"
    assert_failure
    assert_output ""
    [ ! -e "$CLIP_FILE" ]
}

@test "edit passes a filetype argument through to nvim" {
    run_zsh "print x | edit json"
    assert_success
    run grep -c "+setfiletype json" "$NVIM_LOG"
    assert_output 1
}

@test "clip feeds the clipboard in and writes the edit back out" {
    printf 'old' >"$CLIP_FILE"
    export NVIM_CONTENT="new"
    run_zsh "clip"
    assert_success
    assert_output "new"
    assert_equal "$(cat "$NVIM_SAW")" "old"
    assert_equal "$(cat "$CLIP_FILE")" "new"
}

@test "clip aborted with :cq keeps the old clipboard" {
    printf 'old' >"$CLIP_FILE"
    export NVIM_STATUS=1
    export NVIM_CONTENT="new"
    run_zsh "clip"
    assert_failure
    assert_output ""
    assert_equal "$(cat "$CLIP_FILE")" "old"
}
