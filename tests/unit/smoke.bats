#!/usr/bin/env bats
load ../helpers/load

@test "bats harness works and assertion libraries load" {
    run echo hello
    assert_success
    assert_output "hello"
}

@test "REPO_ROOT points at the dotfiles repo" {
    assert [ -f "$REPO_ROOT/zsh/.config/zsh/.zshrc" ]
}

@test "fixtures: mk_git_repo creates a repo with a commit" {
    mk_git_repo "$BATS_TEST_TMPDIR/r"
    run git -C "$BATS_TEST_TMPDIR/r" rev-parse --abbrev-ref HEAD
    assert_success
    assert_output "main"
}
