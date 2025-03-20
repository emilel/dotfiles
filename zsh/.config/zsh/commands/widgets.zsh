expand_alias() {
    local alias_name="$LBUFFER"
    LBUFFER=$( alias "$alias_name" | grep -Po ".*='\K.*(?=')" )
}
zle -N expand_alias
bindkey '^A' expand_alias
bindkey -M vicmd '^A' expand_alias

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

zle -N get_branch
bindkey '^B' get_branch
bindkey _M vicmd '^B' get_branch
