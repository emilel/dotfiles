#!/bin/zsh

# add colors to ls
alias ls='ls --color=auto'

# neovim in read only mode
alias view='nvim -R'

# temporary neovim buffer
alias temp='nvim +TempFile'

# edit clipboard
alias clip='nvim +Clip'

# go up a directory
alias up='cd ..'

# go back a directory
alias back='cd -'

# reload zsh configuration
alias reload='source ~/.config/zsh/.zshrc'

# get ip
alias whatsmyip='curl icanhazip.com'

# python
alias py='python3'
alias ipython='python3 -m IPython'
alias ipy='ipython'
alias iipy='ipython -i'

# include hidden and ignored files with ripgrep/fd-find
alias rgh='rg --hidden --no-ignore'
alias fdh='fd --hidden --no-ignore'

# list files by date
# alias ll='fd . --exec-batch ls -lt -d1'

# diff
alias diffc='diff --color'

# go to tmp directory
alias tmp='cd ~/tmp'

# open without output
open() {
    command open "$@" >/dev/null 2>&1 &disown
}

__ll_dirs() {
    local include_dot=$1 entry epoch hts size formatted
    local -a lines=()
    # choose globs
    local dir_glob=(*/)
    (( include_dot )) && dir_glob=(.* */)

    for entry in "${dir_glob[@]}"; do
        [[ $entry == . || $entry == .. ]] && continue
        [[ ! -d $entry ]] && continue

        # freshest‐inside timestamp
        epoch=$(find "$entry" -type f -printf '%T@\n' 2>/dev/null \
            | sort -nr | head -n1)
        if [[ -z $epoch ]]; then
            epoch=$(stat -c '%Y' -- "$entry")
        else
            epoch=${epoch%.*}
        fi

        hts=$(date -d "@$epoch" '+%Y-%m-%d %H:%M:%S')
        size=$(du -sh --apparent-size -- "$entry" 2>/dev/null | cut -f1)
        formatted=$(printf "%-8s %s \e[1;34m%s\e[0m" \
            "$size" "$hts" "$entry")
        lines+=("$epoch|$formatted")
    done

    printf "%s\n" "${lines[@]}" \
        | sort -t'|' -nr -k1,1 \
        | cut -d'|' -f2-
}

# Core: list files  (include_dot=0 or 1)
__ll_files() {
    local include_dot=$1 entry epoch hts size formatted
    local -a lines=()
    local file_glob=(*)
    (( include_dot )) && file_glob=(.* *)

    for entry in "${file_glob[@]}"; do
        [[ $entry == . || $entry == .. ]] && continue
        [[ ! -f $entry ]] && continue

        epoch=$(stat -c '%Y' -- "$entry")
        hts=$(stat -c '%y' -- "$entry" | sed -E 's/\.[0-9]+.*//')
        size=$(du -sh --apparent-size -- "$entry" 2>/dev/null | cut -f1)
        formatted=$(printf "%-8s %s %s" \
            "$size" "$hts" "$entry")
        lines+=("$epoch|$formatted")
    done

    printf "%s\n" "${lines[@]}" \
        | sort -t'|' -nr -k1,1 \
        | cut -d'|' -f2-
}

# Public wrappers
lld()  { __ll_dirs 0; }            # normal dirs only
llf()  { __ll_files 0; }           # normal files only
ll()   { lld; llf; }               # dirs first, then files

llad() { __ll_dirs 1; }            # dot+normal dirs
llaf() { __ll_files 1; }           # dot+normal files
lla()  { llad; llaf; }             # dot+normal dirs, then files
