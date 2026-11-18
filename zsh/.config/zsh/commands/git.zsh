#!/bin/zsh

# --- git worktrees -----------------------------------------------------------
# A normal clone with its extra branches in .worktrees/<branch-with-dashes>,
# same layout ~/arbuscular uses. The heavy lifting (fetch-first,
# fast-forward-only, paths off the main checkout) lives in git_worktree.sh,
# which prints the worktree path; these wrappers just cd into it. Agents can
# call git_worktree.sh directly and capture the path.

gct() { local d; d=$(git_worktree.sh clone "$@") && cd "$d"; } # clone a repo
gwn() { local d; d=$(git_worktree.sh new "$@") && cd "$d"; }   # new branch off origin default
gwa() { local d; d=$(git_worktree.sh add "$@") && cd "$d"; }   # add worktree for existing branch
gws() { git_worktree.sh sync "$@"; }                           # fetch + ff-only (align w/ origin)
gwrm() { git_worktree.sh prune-merged "$@"; }                  # remove merged worktrees
gw() { local d; d=$(git_worktree.sh switch) && cd "$d"; }      # fzf-jump between worktrees
gwr.() { local d; d=$(git_worktree.sh remove "$@") && cd "$d"; } # remove current worktree

alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove --force'

# --- git shortcuts -----------------------------------------------------------
# one-line log; gl [n] (default 10)
gl() {
    local n="${1:-10}"
    git log --pretty=format:"%C(yellow)%h%Creset %Cgreen%as%Creset %C(magenta)%ad%Creset %Cblue%an%Creset: %s" \
        --date=format:%H:%M -"${n}"
}

# rename the current tmux session/window after the branch's last path segment
alias trn="gb | awk -F'/' '{print \$NF}' | xargs tmux rename-session && tmux rename-window code"

alias gc='git checkout'
alias gr='git reset HEAD~1'
alias grs='git reset --soft HEAD~1'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gp='git pull'
alias gpk='git push'
alias gm='git merge'
