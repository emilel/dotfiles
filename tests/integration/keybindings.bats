#!/usr/bin/env bats
# Freeze the ZLE keybindings: vi-mode + the custom widgets + the fzf binds must
# stay bound to the same keys across the refactor.
load ../helpers/load

setup() {
    use_stubs
    export HOME="$BATS_TEST_TMPDIR/home"
    export XDG_CACHE_HOME="$BATS_TEST_TMPDIR/cache"
    mkdir -p "$HOME"
    Z="$REPO_ROOT/zsh/.config/zsh"
    # vi-mode first (sets the main keymap to viins), then widgets, then fzf binds.
    # NB: zsh doesn't word-split unquoted expansions, so build the -M flag as an
    # array rather than `${1:+-M $1}`.
    SRC="source '$Z/settings/behavior.zsh'
         source '$Z/commands/widgets.zsh'
         source '$REPO_ROOT/fzf/.config/zsh/programs/fzf.zsh'
         check() {
             local map=\$1 key=\$2 want=\$3; local -a flag
             [[ -n \$map ]] && flag=(-M \$map)
             bindkey \$flag \"\$key\" | grep -q \"\$want\" \
                 || { print -u2 \"unbound: [\$map] \$key -> \$want\"; exit 1; }
         }"
}

@test "custom command-line widgets stay bound to their keys" {
    run zsh -c "$SRC
        check '' '^Y' toggle_copy
        check vicmd '^Y' toggle_copy
        check '' '^E' toggle_view
        check '' '^N' redirect_to_stdout
        check '' '^H' go_to_root
        check vicmd '^H' go_to_root
        check viins '^W' backward-kill-word
        check vicmd '^W' backward-kill-word
        check viins '^U' run_tmux_setup"
    assert_success
}

@test "fzf widgets stay bound to ^G and ^F" {
    run zsh -c "$SRC
        check viins '^G' fzf-cd-widget
        check viins '^F' fzf-file-widget"
    assert_success
}
