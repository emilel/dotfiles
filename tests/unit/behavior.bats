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

@test "behavior.zsh enables vi insert mode bindings" {
    run zsh -c "source '$B'; bindkey -lL main | grep -q viins && echo ok"
    assert_success
}
