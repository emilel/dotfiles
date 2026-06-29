#!/usr/bin/env bats
load ../helpers/load

setup() {
    FUNCS="$REPO_ROOT/zsh/.config/zsh/commands/functions.zsh"
    T="$BATS_TEST_TMPDIR"
}

@test "dog fences a python file with the right language tag" {
    printf 'print("hi")\n' >"$T/foo.py"
    run zsh -c "source '$FUNCS'; dog '$T/foo.py'"
    assert_success
    assert_line --index 0 "$T/foo.py:"
    assert_line --index 1 '```python'
    assert_line --index 2 'print("hi")'
    assert_line --index 3 '```'
}

@test "dog inserts a newline before the closing fence when no trailing newline" {
    printf 'no-newline' >"$T/bar.sh"
    run zsh -c "source '$FUNCS'; dog '$T/bar.sh'"
    assert_success
    assert_line --index 1 '```bash'
    assert_line --index 2 'no-newline'
    assert_line --index 3 '```'
}

@test "dog reports a missing file on stderr and keeps going" {
    printf 'x\n' >"$T/ok.md"
    run --separate-stderr zsh -c "source '$FUNCS'; dog '$T/nope' '$T/ok.md'"
    assert_success
    assert_equal "$stderr" "dog: no such file: $T/nope"
    assert_line --index 1 '```markdown'
}
