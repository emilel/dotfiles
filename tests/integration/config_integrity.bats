#!/usr/bin/env bats
# Source the whole zsh config the way stow assembles it, in a throwaway HOME, and
# assert it stays coherent. These are the regression-freeze checks that catch the
# bug classes we found (gct -> missing script, gwr. -> undefined find_git_root).
load ../helpers/load

setup() {
    use_stubs
    export HOME="$BATS_TEST_TMPDIR/home"
    export XDG_CONFIG_HOME="$BATS_TEST_TMPDIR/cfg"
    export XDG_CACHE_HOME="$BATS_TEST_TMPDIR/cache"
    export XDG_SESSION_TYPE=wayland
    mkdir -p "$HOME"
    assemble_zdotdir "$XDG_CONFIG_HOME/zsh"
    ln -s "$REPO_ROOT/scripts/.scripts" "$HOME/.scripts"
    ZRC="$XDG_CONFIG_HOME/zsh/.zshrc"
}

@test "the whole config sources cleanly with no error output" {
    run --separate-stderr zsh -c "source '$ZRC'"
    assert_success
    assert_equal "$stderr" ""
}

@test "expected functions are defined after load" {
    run zsh -c "source '$ZRC'
        for fn in dog edit clip copy copyc gwa gwn gl toggle_copy go_to_root n; do
            typeset -f \$fn >/dev/null || { print -u2 \"missing function: \$fn\"; exit 1; }
        done"
    assert_success
}

@test "expected aliases are defined after load" {
    run zsh -c "source '$ZRC'
        for al in gs gd gc gb gwl gwp gwr ls view paster reload py t ta tt rnw lock so; do
            alias \$al >/dev/null || { print -u2 \"missing alias: \$al\"; exit 1; }
        done"
    assert_success
}

@test "every script-path alias resolves to an executable (guards gct)" {
    run zsh -c "source '$ZRC'
        bad=0
        for line in \${(f)\"\$(alias -L)\"}; do
            val=\${(Q)line#*=}
            tok=\${val%% *}
            if [[ \$tok == */.scripts/* && ! -x \$tok ]]; then
                print -u2 \"unresolved script alias: \$line\"; bad=1
            fi
        done
        exit \$bad"
    assert_success
}

@test "no alias calls an undefined command via \$(...) (guards gwr. -> find_git_root)" {
    run zsh -c "source '$ZRC'
        bad=0
        for line in \${(f)\"\$(alias -L)\"}; do
            rest=\$line
            while [[ \$rest == *'\$('* ]]; do
                rest=\${rest#*'\$('}
                cmd=\${rest%%[\\ \\)]*}
                [[ -n \$cmd ]] && ! whence -- \$cmd >/dev/null 2>&1 \
                    && { print -u2 \"undefined command in alias: \$cmd  (\$line)\"; bad=1; }
            done
        done
        exit \$bad"
    assert_success
}
