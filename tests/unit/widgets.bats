#!/usr/bin/env bats
load ../helpers/load

setup() { W="$REPO_ROOT/zsh/.config/zsh/commands/widgets.zsh"; }

@test "widgets.zsh sources cleanly in a non-interactive shell" {
    run --separate-stderr zsh -c "source '$W'"
    assert_success
    assert_equal "$stderr" ""
}

@test "_buffer_toggle appends the suffix with a separating space" {
    run zsh -c "source '$W'; _buffer_toggle '| copy' 'ls -la'"
    assert_output 'ls -la | copy'
}

@test "_buffer_toggle does not double the space when the buffer ends in one" {
    run zsh -c "source '$W'; _buffer_toggle '| copy' 'ls '"
    assert_output 'ls | copy'
}

@test "_buffer_toggle strips the suffix and its leading space when present" {
    run zsh -c "source '$W'; _buffer_toggle '| copy' 'ls -la | copy'"
    assert_output 'ls -la'
}

@test "_buffer_toggle handles an empty buffer" {
    run zsh -c "source '$W'; _buffer_toggle '2>&1' ''"
    assert_output '2>&1'
}
