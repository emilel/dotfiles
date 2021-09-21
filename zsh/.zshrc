# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# fucking java
# export JDTLS_HOME='/home/emil/install/jdt'

# general
export EDITOR='nvim'
export PAGER='nvim -R -u ~/.vimrc.view +AnsiEsc'
export SPLIT=h
export MANPAGER='nvim +Man! -R -u ~/.vimrc.view'

# path
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.poetry/bin:$PATH"
export PATH="$HOME/install/spotify-tui-linux:$PATH"
export PATH="$HOME/install/spotifyd/target/release:$PATH"
export PATH="$HOME/.installed:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.scripts:$PATH"

# nnn
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tui;a:fzopen;s:fzcd;o:open-selected;e:open-editor;j:duplicate;c:copy'

# plugins
source "$HOME/.zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
plugins=(git vi-mode zsh-autosuggestions zsh-syntax-highlighting)

# oh-my-zsh
# export ZSH=$HOME/.oh-my-zsh
# source $ZSH/oh-my-zsh.sh

# fzf
export FZF_DEFAULT_COMMAND="fd --type f --color=never --hidden"
export FZF_DEFAULT_OPTS='--preview-window=down'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS='--preview-window=down --no-height --preview "bat --color=always --line-range :50 {}"'
export FZF_ALT_C_COMMAND="fd --type d --exclude .git --color=never --hidden"
export FZF_ALT_C_OPTS='--preview-window=down --no-height --preview "tree -L 1 -C {} | head -50"'
export FZF_CTRL_R_OPTS='--preview-window=down'
source $HOME/.vim/plugged/fzf/shell/key-bindings.zsh
source $HOME/.vim/plugged/fzf/shell/completion.zsh
setopt hist_ignore_dups

# dont buffer python stdout/stderr
export PYTHONUNBUFFERED=true

# ripgrep
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# computer specific stuff
# . $HOME/.scripts/.read_computer_specific.sh

# zsh
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
CASE_SENSITIVE="false"
KEYTIMEOUT=1
unsetopt correct_all
setopt globdots
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit
zmodload -i zsh/complist

# läs in skit
source ~/.zsh_aliases

# theme
source ~/.zsh/plugins/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
