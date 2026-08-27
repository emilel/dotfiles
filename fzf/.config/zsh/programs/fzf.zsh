# #!/bin/bash

# `fzf --zsh` is a fork per shell for output that only changes when fzf itself
# does; cache it and regenerate when the binary is newer than the cache.
FZF_INIT="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-init.zsh"
if [[ ! -s "$FZF_INIT" || $commands[fzf] -nt "$FZF_INIT" ]]; then
    [[ -d "${FZF_INIT:h}" ]] || mkdir -p "${FZF_INIT:h}"
    fzf --zsh >|"$FZF_INIT"
fi
source "$FZF_INIT"
unset FZF_INIT

# use tmux by default
export FZF_TMUX=1

# use hidden files by default (--cycle is an fzf flag, fd rejects it)
export FZF_DEFAULT_COMMAND='fd --hidden'
export FZF_DEFAULT_OPTS='--cycle'

# unbind default key bindings
bindkey -rM emacs '\ec'
bindkey -rM vicmd '\ec'
bindkey -rM viins '\ec'
bindkey -rM emacs '\C-t'
bindkey -rM vicmd '\C-t'
bindkey -rM viins '\C-t'

# ctrl g to go to folder
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git --no-ignore"
# export FZF_ALT_C_OPTS="--preview-window=down --preview 'tree -C {}'"
zle -N fzf-cd-widget
bindkey -M emacs '\C-g' fzf-cd-widget
bindkey -M vicmd '\C-g' fzf-cd-widget
bindkey -M viins '\C-g' fzf-cd-widget

# c-f to fuzzy find file
export FZF_CTRL_T_COMMAND='fd --hidden --exclude .git --exclude .venv --no-ignore'
# export FZF_CTRL_T_OPTS='--preview-window=down --no-height --preview "bat --color=always --line-range :50 {}"'
zle -N fzf-file-widget
bindkey -M emacs '\C-f' fzf-file-widget
bindkey -M vicmd '\C-f' fzf-file-widget
bindkey -M viins '\C-f' fzf-file-widget
