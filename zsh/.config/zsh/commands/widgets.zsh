expand_alias() {
    local expansion
    expansion=$( alias "$LBUFFER" 2>/dev/null | sed -E "s/^$LBUFFER='(.*)'/\1/" )
    if [[ -n "$expansion" ]]; then
        LBUFFER=$expansion
    fi
    zle redisplay
}
zle -N expand_alias
bindkey '^A' expand_alias

save_alias() {
    local command="$LBUFFER"
    LBUFFER="alias ='$command'"
    CURSOR=${#${LBUFFER%%=*}}
}
zle -N save_alias
bindkey '^O' save_alias
bindkey -M vicmd '^O' save_alias

toggle_copy() {
    if [[ -z $BUFFER ]]; then
        BUFFER='!!'
        zle expand-history
        BUFFER+=" | copy"
        zle accept-line
    else
        if [[ $BUFFER == *" | copy" ]]; then
            BUFFER=${BUFFER%" | copy"}
        else
            BUFFER+=" | copy"
            CURSOR=${#BUFFER}
        fi
    fi
}
zle -N toggle_copy
bindkey '^Y' toggle_copy
bindkey -M vicmd '^Y' toggle_copy

redirect_to_stdout() {
    if [[ $BUFFER == *" 2>&1" ]]; then
        BUFFER=${BUFFER%" 2>&1"}
    else
        BUFFER+=" 2>&1"
        CURSOR=${#BUFFER}
    fi
}
zle -N redirect_to_stdout
bindkey '^N' redirect_to_stdout
bindkey -M vicmd '^N' redirect_to_stdout

debug() {
    if [[ -z $BUFFER ]]; then
        BUFFER='!!'
        zle expand-history
    fi
    LBUFFER="gdb --args $LBUFFER"
    CURSOR=${#BUFFER}
}
zle -N debug
bindkey '^B' debug
bindkey -M vicmd '^B' debug

go_to_root() {
    cd $(find_git_root)
}
zle -N go_to_root
bindkey '^H' go_to_root
bindkey -M vicmd '^H' go_to_root

zle -N get_branch
bindkey '^T' get_branch
bindkey -M vicmd '^T' get_branch

zle -N go_to_parent
bindkey '^K' go_to_parent
bindkey _M vicmd '^K' go_to_parent
