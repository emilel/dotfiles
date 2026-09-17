#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/claude_notify.sh"
    export TMUX_LOG="$BATS_TEST_TMPDIR/tmux.log"
    export NOTIFY_LOG="$BATS_TEST_TMPDIR/notify.log"
    export TMUX_PANE='%3'
    export TMUX_DISPLAY='dots:2 claude'
}

@test "a permission prompt paints the window red and notifies" {
    run sh "$S" red
    assert_success
    run cat "$TMUX_LOG"
    assert_line "set -w -t %3 @claude red"
    run cat "$NOTIFY_LOG"
    assert_output --partial 'dots:2 claude'
    assert_output --partial '-u critical'
}

@test "finishing paints it green and notifies" {
    run sh "$S" green
    assert_success
    run cat "$TMUX_LOG"
    assert_line "set -w -t %3 @claude green"
    run cat "$NOTIFY_LOG"
    assert_output --partial '-u normal'
    assert_output --partial 'done'
}

@test "the colour and the popup leave on the same call" {
    export TMUX_PANE_TTY="$BATS_TEST_TMPDIR/pane_tty"
    : >"$TMUX_PANE_TTY"
    run sh "$S" green
    assert_success
    # the bell is what colours the window, so it has to be rung here and not
    # waited on -- and the status line repainted rather than left to catch up
    printf '\a' >"$BATS_TEST_TMPDIR/expected"
    assert_equal "$(cat "$TMUX_PANE_TTY")" "$(cat "$BATS_TEST_TMPDIR/expected")"
    run cat "$TMUX_LOG"
    assert_line "refresh-client -S"
    [ -s "$NOTIFY_LOG" ]
}

@test "a pane with no tty of its own is not an error" {
    export TMUX_PANE_TTY=""
    run sh "$S" green
    assert_success
    run cat "$NOTIFY_LOG"
    assert_output --partial 'done'
}

@test "green does not overwrite a window already waiting on permission" {
    export TMUX_SHOW=red
    run sh "$S" green
    assert_success
    run cat "$TMUX_LOG"
    refute_line --partial "@claude green"
    [ ! -s "$NOTIFY_LOG" ]
}

@test "repeat notifications for one window replace each other" {
    run sh "$S" red
    assert_success
    run cat "$NOTIFY_LOG"
    assert_output --partial 'x-canonical-private-synchronous:claude-dots:2 claude'
}

@test "outside tmux it still notifies, just without a window name" {
    unset TMUX_PANE
    run sh "$S" red
    assert_success
    [ ! -e "$TMUX_LOG" ]
    run cat "$NOTIFY_LOG"
    assert_output --partial 'claude'
}

@test "no notify-send (a tty, a server) is not an error" {
    bare="$BATS_TEST_TMPDIR/bin"
    mkdir -p "$bare"
    ln -sf "$STUBS/tmux" "$bare/tmux"
    run env PATH="$bare" /bin/sh "$S" green
    assert_success
}
