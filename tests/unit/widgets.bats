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

@test "_cd_command quotes a path with a space" {
    run zsh -c "source '$W'; _cd_command '/a b/c'"
    assert_output 'cd -- /a\ b/c'
}

@test "_cd_command keeps a dir that starts with a dash out of cd's options" {
    run zsh -c "source '$W'; _cd_command '-x'"
    assert_output 'cd -- -x'
}

@test "^T jumps to a worktree, in every keymap" {
    run zsh -c "source '$W'
        bindkey '^T'; bindkey -M viins '^T'; bindkey -M vicmd '^T'"
    assert_success
    assert_line --index 0 --partial 'go_to_worktree'
    assert_line --index 1 --partial 'go_to_worktree'
    assert_line --index 2 --partial 'go_to_worktree'
}

@test "in a tmux popup M-r is bound to quit, in both keymaps" {
    run zsh -c "TMUX_POPUP=1; source '$W'
        bindkey '^[r'; bindkey -M vicmd '^[r'"
    assert_success
    assert_line --index 0 --partial 'popup_close'
    assert_line --index 1 --partial 'popup_close'
}

@test "outside a popup M-r stays unbound" {
    run zsh -c "unset TMUX_POPUP; source '$W'; bindkey '^[r'"
    refute_output --partial 'popup_close'
}

@test "^H targets the repo root from a subdirectory" {
    mk_git_repo "$BATS_TEST_TMPDIR/repo"
    mkdir -p "$BATS_TEST_TMPDIR/repo/a/b"
    run zsh -c "source '$W'; cd '$BATS_TEST_TMPDIR/repo/a/b'; _repo_jump_target"
    assert_output "$BATS_TEST_TMPDIR/repo"
}

@test "^H targets the main checkout from the root of one of its worktrees" {
    mk_git_repo "$BATS_TEST_TMPDIR/repo"
    git -C "$BATS_TEST_TMPDIR/repo" worktree add -q -b feat "$BATS_TEST_TMPDIR/repo/.worktrees/feat"
    run zsh -c "source '$W'; cd '$BATS_TEST_TMPDIR/repo/.worktrees/feat'; _repo_jump_target"
    assert_output "$BATS_TEST_TMPDIR/repo"
}

@test "^H targets the dir above the repo from the main checkout's own root" {
    mk_git_repo "$BATS_TEST_TMPDIR/repo"
    run zsh -c "source '$W'; cd '$BATS_TEST_TMPDIR/repo'; _repo_jump_target"
    assert_output "$BATS_TEST_TMPDIR"
}

@test "^H targets nothing, quietly, outside a repo" {
    mkdir -p "$BATS_TEST_TMPDIR/plain"
    run --separate-stderr zsh -c "source '$W'; cd '$BATS_TEST_TMPDIR/plain'; _repo_jump_target"
    assert_failure
    assert_output ''
    assert_equal "$stderr" ''
}

@test "^H jumps to the root, in every keymap" {
    run zsh -c "source '$W'
        bindkey '^H'; bindkey -M viins '^H'; bindkey -M vicmd '^H'"
    assert_success
    assert_line --index 0 --partial 'go_to_root'
    assert_line --index 1 --partial 'go_to_root'
    assert_line --index 2 --partial 'go_to_root'
}
