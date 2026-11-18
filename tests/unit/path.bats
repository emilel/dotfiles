#!/usr/bin/env bats
load ../helpers/load

setup() {
    FUNCS="$REPO_ROOT/zsh/.config/zsh/commands/functions.zsh"
    T="$BATS_TEST_TMPDIR"
    mkdir -p "$T/a/b" "$T/c"
}

@test "path is relative to cwd by default" {
    run zsh -c "source '$FUNCS'; cd '$T/a'; path '$T/a/b/x.txt'"
    assert_success
    assert_output "b/x.txt"
}

@test "path takes a base to be relative to" {
    run zsh -c "source '$FUNCS'; cd '$T'; path a/b/x.txt c"
    assert_success
    assert_output "../a/b/x.txt"
}

@test "path follows symlinks to the real file" {
    ln -s "$T/a/b" "$T/link"
    run zsh -c "source '$FUNCS'; cd '$T'; path link"
    assert_success
    assert_output "a/b"
}

@test "fpath follows symlinks to the real file" {
    touch "$T/a/b/x.txt"
    ln -s "$T/a/b/x.txt" "$T/c/link.txt"
    run zsh -c "source '$FUNCS'; fpath '$T/c/link.txt'"
    assert_success
    assert_output "$T/a/b/x.txt"
}

@test "fpath is absolute, defaulting to cwd" {
    run zsh -c "source '$FUNCS'; cd '$T/a'; fpath b/../b/x.txt; fpath"
    assert_success
    assert_line --index 0 "$T/a/b/x.txt"
    assert_line --index 1 "$T/a"
}

@test "path and fpath leave zsh's path arrays alone" {
    run zsh -c "source '$FUNCS'; print -- \$path[1] \$fpath[1]"
    assert_success
    refute_output " "
}
