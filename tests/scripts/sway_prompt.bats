#!/usr/bin/env bats
# The fullscreen prompt ($mod+d, $mod+m) and the launcher on top of it.
load ../helpers/load

setup() {
    use_stubs
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"
    ln -s "$REPO_ROOT/scripts/.scripts" "$HOME/.scripts"
    export SWAY_LOG="$BATS_TEST_TMPDIR/sway_log"
    export TOFI_LOG="$BATS_TEST_TMPDIR/tofi_log"
    PROMPT="$REPO_ROOT/scripts/.scripts/sway_prompt.sh"
    LAUNCH="$REPO_ROOT/scripts/.scripts/sway_launch.sh"
}

@test "prompt reads stdin by default and prints the pick" {
    export TOFI_PICK=web
    run sh "$PROMPT" --prompt-text 'rename: ' <<<"web"
    assert_success
    assert_output web
    run cat "$TOFI_LOG"
    assert_output --partial "tofi "
    assert_output --partial "--prompt-text rename: "
}

@test "prompt --run switches to the \$PATH lister, without passing --run on" {
    export TOFI_PICK=firefox
    run sh "$PROMPT" --run </dev/null
    assert_success
    run cat "$TOFI_LOG"
    assert_output --partial "tofi-run "
    refute_output --partial -- --run
}

@test "prompt passes the font as a file path when the font is installed" {
    font="$HOME/.fonts/adobe-fonts/source-code-pro/OTF/SourceCodePro-Regular.otf"
    mkdir -p "$(dirname "$font")"
    : >"$font"
    run sh "$PROMPT" </dev/null
    assert_success
    run cat "$TOFI_LOG"
    assert_output --partial "--font $font"
}

@test "prompt falls back to the font name when the file is missing" {
    run sh "$PROMPT" </dev/null
    assert_success
    run cat "$TOFI_LOG"
    assert_output --partial "--font Source Code Pro"
}

@test "launch hands the picked command to sway, not to itself" {
    export TOFI_PICK=firefox
    run sh "$LAUNCH" </dev/null
    assert_success
    run cat "$SWAY_LOG"
    assert_output --partial "exec -- firefox"
}

@test "launch does nothing when escape closes the prompt" {
    export TOFI_STATUS=1
    run sh "$LAUNCH" </dev/null
    assert_success
    assert_output ""
    [ ! -s "$SWAY_LOG" ]
}

@test "launch does nothing on an empty pick" {
    export TOFI_PICK=""
    run sh "$LAUNCH" </dev/null
    assert_success
    [ ! -s "$SWAY_LOG" ]
}
