### powerlevel10k - should stay below lines that may require input, above everything else.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# general

## use the best editor of course
export EDITOR='nvim'

## use the best editor as a pager as well
export PAGER='nvim -R -u ~/.vimrc.view +AnsiEsc'

## and use the best editor as a man pager
export MANPAGER='nvim +Man! -R -u ~/.vimrc.view'

# path

## poetry
export PATH="$HOME/.poetry/bin:$PATH"

## programs from aur
export PATH="$HOME/.installed:$PATH"

## where some programs like to hang out
export PATH="$HOME/.local/bin:$PATH"

## personal scripts
export PATH="$HOME/.scripts:$PATH"

# plugins

## use system clipboard when editing commands
source ~/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh

## vi style key bindings when editing commands
source ~/.zsh/plugins/vi-mode/vi-mode.plugin.zsh

## syntax highlighting when executing commands, how cool is that
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

## auto suggest previous commands, and even complete commands
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

## aww yiss, fzf
zle -N fzf-file-widget
zle -N fzf-cd-widget
source ~/.vim/plugged/fzf/shell/key-bindings.zsh
source ~/.vim/plugged/fzf/shell/completion.zsh

# program settings

# nnn
export SPLIT=h
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;a:fzopen;s:fzcd;o:open-selected;e:open-editor;j:duplicate;c:copy'

## fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden"
export FZF_DEFAULT_OPTS='--preview-window=down'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview-window=down --no-height --preview "bat --color=always --line-range :50 {}"'
export FZF_ALT_C_COMMAND="fd --type d --exclude .git --color=never --hidden"
export FZF_ALT_C_OPTS='--preview-window=down --no-height --preview "tree -L 1 -C {} | head -50"'
export FZF_CTRL_R_OPTS='--preview-window=down'
setopt hist_ignore_dups

# fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden"
export FZF_DEFAULT_OPTS='--preview-window=down'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview-window=down --no-height --preview "bat --color=always --line-range :50 {}"'
export FZF_ALT_C_COMMAND="fd --type d --exclude .git --color=never --hidden"
export FZF_ALT_C_OPTS='--preview-window=down --no-height --preview "tree -L 1 -C {} | head -50"'
export FZF_CTRL_R_OPTS='--preview-window=down'
setopt hist_ignore_dups

# zsh

## escape to normal mode immediately
KEYTIMEOUT=1

## command history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt hist_ignore_dups

## ignore case when autocompleting
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

## for some reason, this prevents zsh from going haywire
autoload -Uz compinit && compinit
zmodload -i zsh/complist

## aliases
source ~/.zsh/zsh_aliases

## auto complete arguments
zmodload zsh/complist
zstyle ':completion:*' menu yes select
bindkey -M menuselect '/' history-incremental-search-forward

## functions
source ~/.zsh/zsh_functions

# ssh key
eval $(keychain --eval --quiet id_ed25519)

# apply theme
source ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.zsh/p10k.zsh ]] || source ~/.zsh/p10k.zsh
