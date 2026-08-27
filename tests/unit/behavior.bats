#!/usr/bin/env bats
load ../helpers/load

setup() {
    B="$REPO_ROOT/zsh/.config/zsh/settings/behavior.zsh"
    export HOME="$BATS_TEST_TMPDIR/home"
    mkdir -p "$HOME"
    export XDG_CACHE_HOME="$BATS_TEST_TMPDIR/cache"
}

@test "behavior.zsh sources cleanly and relocates the compdump to the cache" {
    run --separate-stderr zsh -c "source '$B'; print -r -- \$ZSH_COMPDUMP"
    assert_success
    assert_output --partial "$XDG_CACHE_HOME/zsh/zcompdump"
    assert [ -f "$XDG_CACHE_HOME/zsh/zcompdump" ]
}

@test ".zshenv disables the distro's compinit so ours is the only one" {
    run --separate-stderr zsh -c "source '$REPO_ROOT/zsh/.zshenv'
        print -r -- \$skip_global_compinit"
    assert_success
    assert_output "1"
}

@test "a fresh compdump takes the -C path, so compinit leaves it alone" {
    D="$XDG_CACHE_HOME/zsh/zcompdump"
    zsh -c "source '$B'" 2>/dev/null
    echo '# sentinel' >>"$D"
    run --separate-stderr zsh -c "source '$B'"
    assert_success
    run grep -c '# sentinel' "$D"
    assert_output "1"
}

@test "a compdump older than a day is re-audited and its mtime refreshed" {
    D="$XDG_CACHE_HOME/zsh/zcompdump"
    zsh -c "source '$B'" 2>/dev/null
    touch -d '25 hours ago' "$D"
    run --separate-stderr zsh -c "source '$B'"
    assert_success
    assert [ -n "$(find "$D" -mmin -5)" ]
}

@test "behavior.zsh enables vi insert mode bindings" {
    run zsh -c "source '$B'; bindkey -lL main | grep -q viins && echo ok"
    assert_success
}
