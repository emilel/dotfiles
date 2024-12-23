# #!/bin/bash

source <(fzf --zsh)

# use tmux by default
export FZF_TMUX=1

# use hidden files by default
export FZF_DEFAULT_COMMAND='fd --hidden --cycle'

# unbind default key bindings
bindkey -rM emacs '\ec'
bindkey -rM vicmd '\ec'
bindkey -rM viins '\ec'
bindkey -rM emacs '\C-t'
bindkey -rM vicmd '\C-t'
bindkey -rM viins '\C-t'

# ctrl g to go to folder
# export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
# export FZF_ALT_C_OPTS="--preview-window=down --preview 'tree -C {}'"
zle -N fzf-cd-widget
bindkey -M emacs '\C-g' fzf-cd-widget
bindkey -M vicmd '\C-g' fzf-cd-widget
bindkey -M viins '\C-g' fzf-cd-widget

# c-f to fuzzy find file
export FZF_CTRL_T_COMMAND='fd --hidden --exclude .git'
# export FZF_CTRL_T_OPTS='--preview-window=down --no-height --preview "bat --color=always --line-range :50 {}"'
zle -N fzf-file-widget
bindkey -M emacs '\C-f' fzf-file-widget
bindkey -M vicmd '\C-f' fzf-file-widget
bindkey -M viins '\C-f' fzf-file-widget
