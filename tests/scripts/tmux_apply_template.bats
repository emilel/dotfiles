#!/usr/bin/env bats
# tmux_apply_template.sh builds a session out of a directory tree:
# <dir>/.setup/<window>/<pane>.sh, one window per subdirectory, one pane per
# script. The scripts print a pane id, which becomes that pane's @label.
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/tmux_apply_template.sh"
    PROJ="$BATS_TEST_TMPDIR/myproj"
    export TMUX_LOG="$BATS_TEST_TMPDIR/log"
    export TMUX_LIST=''
    unset TMUX
}

# mk_pane <window> <pane> -- a pane script that reports the id it was given
mk_pane() {
    mkdir -p "$PROJ/.setup/$1"
    cat >"$PROJ/.setup/$1/$2.sh" <<EOF
#!/bin/sh
echo "%$3"
EOF
    chmod +x "$PROJ/.setup/$1/$2.sh"
}

@test "creates a session named after the directory" {
    mkdir -p "$PROJ"
    run sh "$S" "$PROJ"
    assert_success
    run cat "$TMUX_LOG"
    assert_line --partial "new-session -d -s myproj -c $PROJ -n scrap"
}

@test "makes one window per .setup subdirectory" {
    mk_pane editor main 1
    mk_pane shell main 2
    run sh "$S" "$PROJ"
    assert_success
    run cat "$TMUX_LOG"
    assert_line --partial "new-window -d -t myproj -n editor"
    assert_line --partial "new-window -d -t myproj -n shell"
}

@test "labels each pane with its script's name, from the id the script printed" {
    mk_pane editor sidebar 7
    run sh "$S" "$PROJ"
    assert_success
    run cat "$TMUX_LOG"
    assert_line --partial "set -t myproj:editor.%7 -p @label sidebar"
}

@test "kills the scratch window it started the session with" {
    mk_pane editor main 1
    run sh "$S" "$PROJ"
    assert_success
    run cat "$TMUX_LOG"
    assert_line --partial "kill-window -t myproj:scrap"
}

@test "opens the window once, however many panes it holds" {
    mk_pane editor one 1
    mk_pane editor two 2
    # the stub answers list-windows from $TMUX_LIST, so say the window is there
    export TMUX_LIST='editor'
    run sh "$S" "$PROJ"
    assert_success
    run grep -c "new-window" "$TMUX_LOG"
    assert_output "0"
}

@test "an existing session is attached, not rebuilt" {
    mk_pane editor main 1
    export TMUX_SESSIONS="myproj"
    run sh "$S" "$PROJ"
    assert_success
    run cat "$TMUX_LOG"
    refute_line --partial "new-session"
    assert_line --partial "attach -t myproj"
}

@test "inside tmux it switches the client instead of attaching" {
    mkdir -p "$PROJ"
    TMUX=/tmp/fake,1,0 run sh "$S" "$PROJ"
    assert_success
    run cat "$TMUX_LOG"
    assert_line --partial "switch-client -t myproj"
    refute_line --partial "attach -t myproj"
}
