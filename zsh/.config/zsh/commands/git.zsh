#!/bin/zsh

# add git branch
gwa() {
    local branch="$1"
    local dir

    if [ "$#" -ge 2 ]; then
        dir="$2"
        shift 2
    else
        dir="$branch"
        shift
    fi

    git worktree add "$dir" "$branch" "$@"
    cd "$dir"
}

# create git branch
gwn() {
    local new_branch="$1"
    local old_branch="${2:-master}"
    git branch "$new_branch" "$old_branch"
    git worktree add "$new_branch" "$new_branch"
    cd "$new_branch"
}

# log one line
gl() {
    n="${1:-10}"
    git log --pretty=format:"%C(yellow)%h%Creset %Cgreen%ad%Creset %Cblue%an%Creset: %s" --date=short -"${n}"
}

alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove --force'
alias gwr.='git worktree remove --force $(find_git_root)'
alias trn="gb | awk -F'/' '{print \$NF}' | xargs tmux rename-session && tmux rename-window code"
