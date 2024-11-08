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
zle -N go_to_git_worktree
bindkey '^T' go_to_git_worktree

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
  git worktree add -b "$new_branch" "$new_branch" "$old_branch"
  cd "$new_branch"
}

alias root='cd $(find_git_root)'
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove --force'
alias gl5='git log --oneline -5'
alias gcm='git checkout master --'
alias gcb="git branch --contains | grep -v 'detached' | head -n 1 | sed 's/* //' | xargs"
alias gsl='git stash list'
alias gpm='cd ~/work/Elliptic.Engine/master && git pull && cd -'
