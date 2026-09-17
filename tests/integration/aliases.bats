#!/usr/bin/env bats
# Freeze the exact definitions of the aliases that matter most, so an accidental
# edit to aliases.zsh / git.zsh is caught.
load ../helpers/load

setup() { Z="$REPO_ROOT/zsh/.config/zsh"; }

@test "core and git aliases keep their exact definitions" {
    run zsh -c "source '$Z/commands/aliases.zsh'; source '$Z/commands/git.zsh'
        typeset -A want=(
            ls 'ls --color=auto --group-directories-first'
            view 'nvim -R'
            reload 'source ~/.config/zsh/.zshrc'
            gs 'git status'
            gd 'git diff'
            gc 'git checkout'
            gb 'git branch'
            gwl 'git worktree list'
        )
        for k in \${(k)want}; do
            got=\${aliases[\$k]}
            [[ \$got == \${want[\$k]} ]] || { print -u2 \"alias \$k: '\$got' != '\${want[\$k]}'\"; exit 1; }
        done"
    assert_success
}
