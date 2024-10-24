#!/bin/zsh

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

# git worktrees
gwb() {
  directory=$(git worktree list | grep -v '\.bare' | awk '{print $1}' | fzf)
  cd $directory
}
alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove'

gwa() {
  local branch="$1"
  git worktree add $1 $1
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
