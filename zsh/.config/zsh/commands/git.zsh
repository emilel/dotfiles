#!/bin/zsh

# find root of git repository
find_git_root() {
  local dir="$PWD"
  while [[ ! -d "$dir/.git" && ! -f "$dir/.git" ]]; do
    dir=$(dirname "$dir")
    if [[ "$dir" == "/" || "$dir" == "." ]]; then
      echo "Error: Git root not found."
      return 1
    fi
  done
  echo "$dir"
}

# go to git worktree
go_to_git_worktree() {
  local directory=$(git worktree list | grep -v '\.bare' | awk '{print $1}' | fzf)
  if [[ -n $directory ]]; then
    cd $directory
    zle reset-prompt
  fi
}

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
zle -N get_branch
bindkey '^T' get_branch

# add git branch
gwa() {
  local branch="$1"
  shift
  git worktree add "$branch" "$branch" "$@"
  cd "$branch"
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
  git log --oneline -"${n}"
}

# soft reset commits
grs() {
  num="${1:-1}"
  git reset --soft HEAD~"${num}"
}

alias ro='cd $(find_git_root)'
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove --force'
alias gc='git checkout'
alias gcm='git checkout master'
alias gb="git branch --contains | grep -v 'detached' | head -n 1 | sed 's/* //' | xargs"
alias gsl='git stash list'
alias gsu='git submodule update --init'
alias gf='fd . | fzf'
