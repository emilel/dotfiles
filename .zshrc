# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zsh
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
KEYTIMEOUT=1
unsetopt correct_all
setopt globdots

# general
export EDITOR='nvim'
export PAGER='bat'
export PATH=~/.npm-global/bin:$PATH
export SPLIT=h
export MANPAGER='nvim +Man!'

# läs in skit
source ~/.zsh_aliases

# nnn
export NNN_FIFO=/tmp/nnn.fifo
source ~/.scripts/nnn_quitcd.sh
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;j:fzopen;j:fzcd;l:open-marked'

# plugins
source "$HOME/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
bindkey -M vicmd 'V' edit-command-line
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting)

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# vim keys to browse tab suggestions
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden"
export FZF_DEFAULT_OPTS='--preview-window=down'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview-window=down --no-height --preview "bat --color=always --line-range :50 {}"'
export FZF_ALT_C_OPTS='--preview-window=down --no-height --preview "tree -L 1 -C {} | head -50"'
export FZF_CTRL_R_OPTS='--preview-window=down'
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
setopt hist_ignore_dups
bindkey '^A' fzf-file-widget
bindkey '^S' fzf-cd-widget

# theme
source ~/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh