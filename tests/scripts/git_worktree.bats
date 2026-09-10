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

# clone proj and leave the shell sitting in the main checkout
clone_proj() {
    (cd "$BATS_TEST_TMPDIR" && sh "$WT" clone "$ORIGIN" proj) >/dev/null 2>&1
    cd "$PROJ"
}

@test "clone lands in the main checkout, on the default branch" {
    cd "$BATS_TEST_TMPDIR"
    run --separate-stderr sh "$WT" clone "$ORIGIN" proj # path on stdout, git chatter on stderr
    assert_success
    assert_output "$PROJ"
    assert [ -d "$PROJ/.git" ]
    run git -C "$PROJ" branch --show-current
    assert_output "main"
}

@test "clone sets the main checkout to track origin" {
    clone_proj
    run git -C "$PROJ" rev-parse --abbrev-ref '@{upstream}'
    assert_output "origin/main"
}

@test "clone keeps .worktrees/ out of git status" {
    clone_proj
    sh "$WT" new wip >/dev/null 2>&1
    run git -C "$PROJ" status --porcelain
    assert_output ""
}

@test "new puts a branch under .worktrees/, slashes flattened" {
    clone_proj
    run sh "$WT" new claude/feat
    assert_success
    assert_output "$PROJ/.worktrees/claude-feat"
    assert [ -d "$PROJ/.worktrees/claude-feat" ]
    run git -C "$PROJ/.worktrees/claude-feat" branch --show-current
    assert_output "claude/feat"
}

@test "new bases off freshly-fetched origin (no drift from a stale local default)" {
    clone_proj                                          # local main = commit2
    git -C "$ORIGIN" commit -q --allow-empty -m commit3 # origin advances
    run sh "$WT" new wip
    assert_success
    # the new branch must sit on origin's *current* tip, not the stale local one
    assert_equal "$(git -C "$PROJ/.worktrees/wip" rev-parse HEAD)" \
        "$(git -C "$ORIGIN" rev-parse main)"
}

@test "new from inside a worktree hangs the next one off the main checkout" {
    clone_proj
    cd "$(sh "$WT" new first 2>/dev/null)"
    run sh "$WT" new second
    assert_success
    assert_output "$PROJ/.worktrees/second" # not nested under first/
}

@test "add attaches an existing origin branch with tracking" {
    clone_proj
    run sh "$WT" add topic
    assert_success
    assert_output "$PROJ/.worktrees/topic"
    run git -C "$PROJ/.worktrees/topic" rev-parse --abbrev-ref '@{upstream}'
    assert_output "origin/topic"
}

@test "sync fast-forwards the current worktree onto origin" {
    clone_proj
    git -C "$ORIGIN" commit -q --allow-empty -m commit3
    run sh "$WT" sync
    assert_success
    assert_equal "$(git -C "$PROJ" rev-parse HEAD)" "$(git -C "$ORIGIN" rev-parse main)"
}

@test "remove deletes the current worktree and prints the main checkout" {
    clone_proj
    cd "$(sh "$WT" new wip 2>/dev/null)"
    run sh "$WT" remove
    assert_success
    assert_output "$PROJ"
    assert [ ! -e "$PROJ/.worktrees/wip" ]
}

@test "remove refuses the main checkout" {
    clone_proj
    run sh "$WT" remove
    assert_failure
    assert_output --partial "main checkout"
    assert [ -d "$PROJ/.git" ]
}

@test "prune-merged removes merged worktrees but keeps the main checkout" {
    clone_proj
    sh "$WT" add merged >/dev/null 2>&1
    assert [ -d "$PROJ/.worktrees/merged" ]
    run sh "$WT" prune-merged
    assert_success
    assert [ ! -e "$PROJ/.worktrees/merged" ]
    assert [ -d "$PROJ/.git" ]
}

@test "switch prints the fzf-picked worktree path" {
    clone_proj
    sh "$WT" new wip >/dev/null 2>&1
    run sh "$WT" switch
    assert_success
    assert_output "$PROJ"
}

# An fzf that records what it was offered, so the picker's menu can be asserted.
record_fzf() {
    cat >"$BATS_TEST_TMPDIR/bin/fzf" <<'EOF'
#!/bin/sh
tee "$FZF_MENU" | head -n1
EOF
    chmod +x "$BATS_TEST_TMPDIR/bin/fzf"
    export FZF_MENU="$BATS_TEST_TMPDIR/menu"
    PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

@test "switch offers branch names, keeping the flattened path hidden" {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    record_fzf
    clone_proj
    sh "$WT" new feature/x >/dev/null 2>&1
    run sh "$WT" switch
    assert_success
    run cat "$FZF_MENU"
    assert_line "main	$PROJ"
    assert_line "feature/x	$PROJ/.worktrees/feature-x"
}

@test "switch hides the harness's throwaway .claude/worktrees agents" {
    mkdir -p "$BATS_TEST_TMPDIR/bin"
    record_fzf
    clone_proj
    git worktree add -q -b agent-tmp "$PROJ/.claude/worktrees/agent-1" 2>/dev/null
    run sh "$WT" switch
    assert_success
    assert_output "$PROJ"
    run cat "$FZF_MENU"
    refute_output --partial ".claude/worktrees"
}
