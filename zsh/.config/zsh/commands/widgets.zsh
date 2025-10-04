toggle_copy() {
    if [[ -z $BUFFER ]]; then
        BUFFER='!!'
        zle expand-history
        BUFFER+=" | copy"
        zle accept-line
    else
        if [[ $BUFFER == *"| copy" ]]; then
            BUFFER=${BUFFER//" | copy"/}
            BUFFER=${BUFFER//"| copy"/}
        else
            if [[ $BUFFER == *" " ]]; then
                BUFFER+="| copy"
            else
                BUFFER+=" | copy"
            fi
            CURSOR=${#BUFFER}
        fi
    fi
}
zle -N toggle_copy
bindkey '^Y' toggle_copy
bindkey -M vicmd '^Y' toggle_copy

redirect_to_stdout() {
    if [[ $BUFFER == *"2>&1" ]]; then
        BUFFER=${BUFFER//" 2>&1"/}
        BUFFER=${BUFFER//"2>&1"/}
    else
        if [[ $BUFFER == *" " ]]; then
            BUFFER+="2>&1"
        else
            BUFFER+=" 2>&1"
        fi
        CURSOR=${#BUFFER}
    fi
}
zle -N redirect_to_stdout
bindkey '^N' redirect_to_stdout
bindkey -M vicmd '^N' redirect_to_stdout

go_to_root() {
    zle push-input
    local repo_root common_dir
    if repo_root=$(git rev-parse --show-toplevel 2>/dev/null); then
        if [[ $PWD == $repo_root ]]; then
            common_dir=$(git rev-parse --git-common-dir | xargs dirname)
            cd "$common_dir" || return
        else
            cd "$repo_root" || return
        fi
    else
        common_dir=$(git rev-parse --git-common-dir | xargs dirname) || return
        cd "$common_dir" || return
    fi
    zle get-line
    zle reset-prompt
}
zle -N go_to_root
bindkey '^H' go_to_root
bindkey -M viins '^H' go_to_root
bindkey -M vicmd '^H' go_to_root
