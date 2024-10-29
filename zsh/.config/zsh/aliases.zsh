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

# git
go_to_git_worktree() {
  directory=$(git worktree list | grep -v '\.bare' | awk '{print $1}' | fzf)
  cd $directory
}
zle -N go_to_git_worktree
bindkey '^T' go_to_git_worktree

alias gwl='git worktree list'
alias gwp='git worktree prune'
alias gwr='git worktree remove'
alias gl5='git log --oneline -5'
alias gcm='git checkout master --'
alias gcb="git branch --contains | grep -v 'detached' | head -n 1 | sed 's/* //' | xargs"

gwa() {
  local branch="$1"
  shift
  git worktree add "$branch" "$branch" "$@"
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
