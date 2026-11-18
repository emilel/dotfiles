#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/nnn_open.sh"
    export EDITOR=nvim VISUAL= NVIM_LOG="$BATS_TEST_TMPDIR/nvim.log"
    export XDG_OPEN_LOG="$BATS_TEST_TMPDIR/xdg.log"
}

opens_in_editor() {
    run sh "$S" "$1"
    assert_success
    run cat "$NVIM_LOG"
    assert_output "nvim $1"
    assert [ ! -f "$XDG_OPEN_LOG" ]
}

opens_in_desktop_app() {
    run sh "$S" "$1"
    assert_success
    run cat "$XDG_OPEN_LOG"
    assert_output "$1"
    assert [ ! -f "$NVIM_LOG" ]
}

@test "json goes to the editor, not the desktop opener" {
    F="$BATS_TEST_TMPDIR/x.json"
    echo '{"a": 1}' >"$F"
    opens_in_editor "$F"
}

@test "plain text goes to the editor" {
    F="$BATS_TEST_TMPDIR/notes.txt"
    echo 'hello' >"$F"
    opens_in_editor "$F"
}

@test "lua that file(1) mistakes for javascript goes to the editor" {
    F="$BATS_TEST_TMPDIR/init.lua"
    printf 'require("core.options")\nrequire("core.keymaps")\n' >"$F"
    opens_in_editor "$F"
}

@test "an empty file goes to the editor" {
    F="$BATS_TEST_TMPDIR/empty"
    : >"$F"
    opens_in_editor "$F"
}

@test "a pdf goes to the desktop opener even when it reads as text" {
    F="$BATS_TEST_TMPDIR/x.pdf"
    printf '%%PDF-1.4\n' >"$F"
    opens_in_desktop_app "$F"
}

@test "svg goes to the desktop opener" {
    F="$BATS_TEST_TMPDIR/x.svg"
    printf '<svg xmlns="http://www.w3.org/2000/svg"/>\n' >"$F"
    opens_in_desktop_app "$F"
}

@test "binary goes to the desktop opener" {
    F="$BATS_TEST_TMPDIR/x.bin"
    printf '\000\001\002\377' >"$F"
    opens_in_desktop_app "$F"
}
