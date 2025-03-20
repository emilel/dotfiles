#!/bin/zsh

# get branch name checked out worktrees
get_branch() {
    local branch
    branch=$(git worktree list | awk '{print $3}' | rg -o '\[(.*?)\]' -r '$1' | fzf) || return

    if [ -z "$LBUFFER" ]; then
        local branch_path
        branch_path=$(git worktree list | awk -v b="$branch" '$3 ~ b {print $1}')
        if [ -n "$branch_path" ]; then
            cd "$branch_path" || return
            zle reset-prompt
        fi
    else
        LBUFFER+="$branch"
    fi
}

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

# soft reset commits
grs() {
    num="${1:-1}"
    git reset --soft HEAD~"${num}"
}

alias find_git_root='git rev-parse --show-toplevel'
alias toro='cd $(find_git_root)'
alias ro='find_git_root'
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove --force'
alias gwr.='git worktree remove --force $(find_git_root)'
alias gc='git checkout'
alias gcm='git checkout master'
alias gsl='git stash list'
alias gsu='git submodule update --init'
alias gf='fd . | fzf'
alias gro='git reset --hard origin/$(gb)'
alias gpus='git push'
alias gpusf='git push --force'
alias gb='git rev-parse --abbrev-ref HEAD'
alias trn="gb | awk -F'/' '{print \$NF}' | xargs tmux rename-session && tmux rename-window code"
alias gfa='git fetch --all'
alias gp='git pull'
alias gd='git diff'
alias gm='git merge'
