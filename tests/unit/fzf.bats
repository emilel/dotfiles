#!/usr/bin/env bats
# fzf's shell init is cached: sourcing it must still define the widgets, but
# without forking fzf on every shell.
load ../helpers/load

setup() {
    F="$REPO_ROOT/fzf/.config/zsh/programs/fzf.zsh"
    export HOME="$BATS_TEST_TMPDIR/home"
    export XDG_CACHE_HOME="$BATS_TEST_TMPDIR/cache"
    mkdir -p "$HOME" "$BATS_TEST_TMPDIR/bin"
    # An fzf whose --zsh output is identifiable and that records each call, so
    # the tests can tell a cache hit from a fork.
    export FZF_CALLS="$BATS_TEST_TMPDIR/calls"
    : >"$FZF_CALLS"
    cat >"$BATS_TEST_TMPDIR/bin/fzf" <<'EOF'
#!/bin/sh
echo call >>"$FZF_CALLS"
echo 'FZF_FROM_CACHE=yes'
EOF
    chmod +x "$BATS_TEST_TMPDIR/bin/fzf"
    PATH="$BATS_TEST_TMPDIR/bin:$PATH"
    CACHE="$XDG_CACHE_HOME/zsh/fzf-init.zsh"
}

@test "the first shell caches fzf's init and still sources it" {
    run --separate-stderr zsh -c "source '$F'; print -r -- \$FZF_FROM_CACHE"
    assert_success
    assert_output "yes"
    assert [ -s "$CACHE" ]
}

@test "a later shell sources the cache instead of forking fzf" {
    zsh -c "source '$F'" 2>/dev/null
    run --separate-stderr zsh -c "source '$F'; print -r -- \$FZF_FROM_CACHE"
    assert_success
    assert_output "yes"
    run wc -l <"$FZF_CALLS"
    assert_output "1"
}

@test "a newer fzf binary invalidates the cache" {
    zsh -c "source '$F'" 2>/dev/null
    touch "$BATS_TEST_TMPDIR/bin/fzf"
    zsh -c "source '$F'" 2>/dev/null
    run wc -l <"$FZF_CALLS"
    assert_output "2"
}
