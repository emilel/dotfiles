#!/bin/zsh

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

# add colors to ls
alias ls='ls --color=auto'

# neovim in read only mode
alias view='nvim -R'

# temporary neovim buffer
alias temp='nvim +TempFile'

# go up a directory
alias up='cd ..'

# go back a directory
alias back='cd -'

# reload zsh configuration
alias reload='source ~/.config/zsh/.zshrc'

# add to local gitignore
alias lgi="$EDITOR .git/info/exclude"

# get ip
alias whatsmyip='curl icanhazip.com'

# python
alias py='python3'
alias ipython='python3 -m IPython'
alias ipy='ipython'

# diff
alias diffc='diff --color'

# go to root of git repository
alias root='cd $(find_git_root)'

# git
go_to_git_worktree() {
  local directory=$(git worktree list | grep -v '\.bare' | awk '{print $1}' | fzf)
  if [[ -n $directory ]]; then
    cd $directory
    zle reset-prompt
  fi
}
zle -N go_to_git_worktree
bindkey '^T' go_to_git_worktree

alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove --force'
alias gl5='git log --oneline -5'
alias gcm='git checkout master --'
alias gcb="git branch --contains | grep -v 'detached' | head -n 1 | sed 's/* //' | xargs"
alias gsl='git stash list'

gwa() {
  local branch="$1"
  shift
  git worktree add "$branch" "$branch" "$@"
  cd "$branch"
}

gwn() {
  local new_branch="$1"
  shift
  local old_branch="$1"
  shift
  git worktree add -b "$new_branch" "$new_branch" "$old_branch"
  cd "$new_branch"
}

# print directory content
catdir() {
  dir=$1
  pattern=${2:-*}
  find "$dir" -type f -name "$pattern" | while read -r file; do
      echo "$file:"
      echo "\`\`\`"
      cat "$file"
      echo "\`\`\`"
      echo
  done
}
