#!/usr/bin/env bats
load ../helpers/load

# TMUX_LIST lines are what `list-windows -a -F` prints: @claude|bell|sess:idx name
setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/tmux_claude_status.sh"
    RED='<span color="#d75f5f">'
    GREEN='<span color="#5faf5f">'
    export TMUX_LOG="$BATS_TEST_TMPDIR/tmux.log"
    export SWAY_JSON='{}' # nothing focused
}

# The sway tree with $1 as the title of the focused window.
focus_on() {
    export SWAY_JSON="{\"nodes\":[{\"name\":\"root\",\"nodes\":[{\"focused\":true,\"name\":\"$1\"}]}]}"
}

@test "prints nothing when no window is flagged" {
    export TMUX_LIST='|0|dots:1 zsh
|0|dots:2 nvim'
    run sh "$S"
    assert_success
    assert_output ""
}

@test "prints nothing when there is no tmux server" {
    export TMUX_LIST=''
    run sh "$S"
    assert_success
    assert_output ""
}

@test "green for a finished claude" {
    export TMUX_LIST='green|0|dots:2 claude'
    run sh "$S"
    assert_success
    assert_output "${GREEN}dots:2 claude</span>"
}

@test "green for a plain bell, claude or not" {
    export TMUX_LIST='|1|dots:3 make'
    run sh "$S"
    assert_success
    assert_output "${GREEN}dots:3 make</span>"
}

@test "red for one blocked on a permission prompt" {
    export TMUX_LIST='red|0|dots:2 claude'
    run sh "$S"
    assert_success
    assert_output "${RED}dots:2 claude</span>"
}

@test "a permission prompt stays red even once it has rung" {
    export TMUX_LIST='red|1|dots:2 claude'
    run sh "$S"
    assert_success
    assert_output "${RED}dots:2 claude</span>"
}

@test "lists every waiting window, each in its own colour" {
    export TMUX_LIST='green|0|dots:2 claude
|0|dots:3 zsh
red|1|rig:1 claude'
    run sh "$S"
    assert_success
    assert_output "${GREEN}dots:2 claude</span>  ${RED}rig:1 claude</span>"
}

@test "the window on screen is not listed -- it's right there" {
    export TMUX_LIST='green|0|dots:2 claude
red|0|rig:1 claude'
    focus_on "dots:2 claude"
    run sh "$S"
    assert_success
    assert_output "${RED}rig:1 claude</span>"
}

@test "the window on screen has its flag cleared, so it stays gone" {
    export TMUX_LIST='green|0|dots:2 claude'
    focus_on "dots:2 claude"
    run sh "$S"
    assert_success
    run cat "$TMUX_LOG"
    assert_line "set -w -t dots:2 -u @claude"
}

@test "a focused window that isn't tmux hides nothing" {
    export TMUX_LIST='green|0|dots:2 claude'
    focus_on "Firefox"
    run sh "$S"
    assert_success
    assert_output "${GREEN}dots:2 claude</span>"
}

@test "escapes pango markup in session and window names" {
    export TMUX_LIST='green|0|a&b:2 <nvim>'
    run sh "$S"
    assert_success
    assert_output "${GREEN}a&amp;b:2 &lt;nvim></span>"
}
