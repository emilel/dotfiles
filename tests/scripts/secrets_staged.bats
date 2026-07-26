#!/usr/bin/env bats
load ../helpers/load

# The secret strings are assembled at runtime so this file itself never
# contains anything the hook (or github) would flag.

setup() {
    command -v gitleaks >/dev/null || skip "gitleaks not installed"
    REPO="$BATS_TEST_TMPDIR/repo"
    mk_git_repo "$REPO"
    git -C "$REPO" commit -qm init --allow-empty
    cp "$REPO_ROOT/sample_hooks/secrets_staged" "$REPO/.git/hooks/pre-commit"
    # the repo config extends the default rules; the hook runs from the repo
    cp "$REPO_ROOT/.gitleaks.toml" "$REPO/.gitleaks.toml"
}

commit_file() { # name content
    printf '%s\n' "$2" >"$REPO/$1"
    git -C "$REPO" add "$1"
    git -C "$REPO" commit -qm x
}

@test "blocks a staged github token" {
    run commit_file creds.txt "token = ghp_$(printf 'aB3dE6gH9jK2mN5pQ8sT1vW4yZ7bC0eF6hJ9')"
    assert_failure
}

@test "blocks the kind of hex key that leaked in 2023" {
    run commit_file work.zsh "export KEY=$(printf '39158d882b%s' 229e53559b)"
    assert_failure
}

@test "lets a normal commit through" {
    run commit_file ok.txt 'just a normal file'
    assert_success
}
