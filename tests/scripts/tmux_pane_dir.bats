#!/usr/bin/env bats
load ../helpers/load

setup() {
    S="$REPO_ROOT/scripts/.scripts/tmux_pane_dir.sh"
    export TMPDIR="$BATS_TEST_TMPDIR/tmp"
    mkdir -p "$TMPDIR"
    WORK="$BATS_TEST_TMPDIR/repo"
    mk_git_repo "$WORK"
    CACHE="$TMPDIR/tmux-git-dirty-$(id -u)"
    KEY=$(printf '%s' "$WORK" | cksum | cut -d' ' -f1)
}

@test "clean tree prints the basename with a two-space suffix" {
    run sh "$S" "$WORK"
    assert_success
    assert_output "repo  "
}

@test "dirty tree prints the basename with a star+space suffix, same width" {
    : >"$WORK/dirty"
    run sh "$S" "$WORK"
    assert_output "repo* "
}

@test "a fresh cache entry is trusted within the TTL" {
    mkdir -p "$CACHE"
    printf '%s %s\n' "$(date +%s)" '*' >"$CACHE/$KEY" # says dirty, just now
    run sh "$S" "$WORK"                               # tree is actually clean...
    assert_output "repo* "                            # ...but the fresh cache wins
}

@test "a stale cache entry is refreshed from the real tree" {
    mkdir -p "$CACHE"
    printf '%s %s\n' "$(($(date +%s) - 100))" '*' >"$CACHE/$KEY" # stale + dirty
    run sh "$S" "$WORK"
    assert_output "repo  " # refreshed: tree is clean, star+space becomes two spaces
}
