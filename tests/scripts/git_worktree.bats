#!/usr/bin/env bats
# Exercises git_worktree.sh end-to-end against a local "origin" repo (no network).
load ../helpers/load

setup() {
    use_stubs # fzf stub, for `switch`
    WT="$REPO_ROOT/scripts/.scripts/git_worktree.sh"
    ORIGIN="$BATS_TEST_TMPDIR/origin"
    PROJ="$BATS_TEST_TMPDIR/proj"
    mk_git_repo "$ORIGIN"            # commit1 on main
    git -C "$ORIGIN" branch topic    # topic  = commit1
    git -C "$ORIGIN" branch merged   # merged = commit1 (ancestor of main)
    git -C "$ORIGIN" commit -q --allow-empty -m commit2 # main = commit2
}

# clone proj and leave the shell sitting in its default worktree
clone_proj() {
    (cd "$BATS_TEST_TMPDIR" && sh "$WT" clone "$ORIGIN" proj) >/dev/null 2>&1
    cd "$PROJ/main"
}

@test "clone builds the bare layout and lands in the default worktree" {
    cd "$BATS_TEST_TMPDIR"
    run --separate-stderr sh "$WT" clone "$ORIGIN" proj # path on stdout, git chatter on stderr
    assert_success
    assert_output "$PROJ/main"
    assert [ -d "$PROJ/.bare" ]
    assert [ -f "$PROJ/.git" ]
    assert [ -d "$PROJ/main" ]
}

@test "clone sets the default worktree to track origin" {
    clone_proj
    run git -C "$PROJ/main" rev-parse --abbrev-ref '@{upstream}'
    assert_output "origin/main"
}

@test "new creates a branch in a dir that mirrors the (slashed) branch name" {
    clone_proj
    run sh "$WT" new claude/feat
    assert_success
    assert_output "$PROJ/claude/feat"
    assert [ -d "$PROJ/claude/feat" ]
    run git -C "$PROJ/claude/feat" branch --show-current
    assert_output "claude/feat"
}

@test "new bases off freshly-fetched origin (no drift from a stale local default)" {
    clone_proj                                          # local main = commit2
    git -C "$ORIGIN" commit -q --allow-empty -m commit3 # origin advances
    run sh "$WT" new wip
    assert_success
    # the new branch must sit on origin's *current* tip, not the stale local one
    assert_equal "$(git -C "$PROJ/wip" rev-parse HEAD)" "$(git -C "$ORIGIN" rev-parse main)"
}

@test "add attaches an existing origin branch with tracking" {
    clone_proj
    run sh "$WT" add topic
    assert_success
    assert_output "$PROJ/topic"
    run git -C "$PROJ/topic" rev-parse --abbrev-ref '@{upstream}'
    assert_output "origin/topic"
}

@test "sync fast-forwards the current worktree onto origin" {
    clone_proj
    git -C "$ORIGIN" commit -q --allow-empty -m commit3
    run sh "$WT" sync
    assert_success
    assert_equal "$(git -C "$PROJ/main" rev-parse HEAD)" "$(git -C "$ORIGIN" rev-parse main)"
}

@test "remove deletes the current worktree and prints the project root" {
    clone_proj
    sh "$WT" new wip >/dev/null 2>&1
    cd "$PROJ/wip"
    run sh "$WT" remove
    assert_success
    assert_output "$PROJ"
    assert [ ! -e "$PROJ/wip" ]
}

@test "prune-merged removes merged worktrees but keeps the default" {
    clone_proj
    sh "$WT" add merged >/dev/null 2>&1
    assert [ -d "$PROJ/merged" ]
    run sh "$WT" prune-merged
    assert_success
    assert [ ! -e "$PROJ/merged" ]
    assert [ -d "$PROJ/main" ]
}

@test "switch prints the fzf-picked worktree path (never the bare entry)" {
    clone_proj
    sh "$WT" new wip >/dev/null 2>&1
    run sh "$WT" switch
    assert_success
    assert_output "$PROJ/main"
}
