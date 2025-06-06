# get nth column
getcol() {
    local start="$1"
    shift
    local end
    if [ "$#" -ge 1 ] && [[ "$1" =~ ^-?[0-9]+$ ]]; then
        end="$1"
        shift
    else
        end="$start"
    fi

    awk -v start="$start" -v end="$end" '
    {
        n = NF
        # Convert negative indices:
        # If start < 0, start = n + start + 1. For example, if start=-1 and n=5, start=5+(-1)+1=5 (last field)
        s = (start < 0 ? n + start + 1 : start)
        e = (end < 0 ? n + end + 1 : end)

        # Clamp indices to valid range
        if (s < 1) s = 1
        if (e < 1) e = 1
        if (s > n) s = n
        if (e > n) e = n

        # Ensure s <= e for proper printing
        if (s > e) {
            # Swap if needed
            tmp = s; s = e; e = tmp;
        }

        for (i = s; i <= e; i++) {
            printf "%s%s", $i, (i < e ? OFS : ORS)
        }
    }' "$@"
}

# get nth row
getrow() {
    local start="$1"
    shift
    local end
    if [ "$#" -ge 1 ] && [[ "$1" =~ ^-?[0-9]+$ ]]; then
        end="$1"
        shift
    else
        end="$start"
    fi

    # Combine all input into a temporary file for line counting
    tmpfile=$(mktemp)
    cat "$@" > "$tmpfile"
    trap 'rm -f "$tmpfile"' EXIT

    total=$(wc -l < "$tmpfile")

    s=$start
    e=$end

    # Convert negative indices:
    # If s < 0, s = total + s + 1
    # If e < 0, e = total + e + 1
    [ $s -lt 0 ] && s=$((total + s + 1))
    [ $e -lt 0 ] && e=$((total + e + 1))

    # Clamp values to valid range
    [ $s -lt 1 ] && s=1
    [ $e -lt 1 ] && e=1
    [ $s -gt $total ] && s=$total
    [ $e -gt $total ] && e=$total

    # Ensure s <= e
    if [ $s -gt $e ]; then
        tmp=$s; s=$e; e=$tmp
    fi

    sed -n "${s},${e}p" "$tmpfile"
}

get() {
    row=$1
    col=$2
    getrow $1 | getcol $col
}

tra() {
    from=$1
    to=$2
    sed "s/$from/$to/g"
}

go_to_parent() {
    target=$(pwd | tr '/' '\n' | sed '1s/^$/\//' | tac | fzf) || return
    candidate_path=$(pwd)
    while true; do
        directory_name=$(basename "$candidate_path")
        if [[ "$directory_name" == "$target" ]]; then
            target_path="$candidate_path"
            break
        fi
        candidate_path=$(dirname "$candidate_path")
    done

    if [[ -z $BUFFER ]]; then
        BUFFER="cd $target_path"
        zle accept-line
    else
        RBUFFER+="$target_path"
        CURSOR=${#BUFFER}
    fi
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

    if (( ${#lines[@]} )); then
        printf '%s\n' "${lines[@]}" | sort -t'|' -nr -k1,1 | cut -d'|' -f2-
    fi
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

    if (( ${#lines[@]} )); then
        printf '%s\n' "${lines[@]}" \
            | sort -t'|' -nr -k1,1 \
            | cut -d'|' -f2-
    fi
}

# Public wrappers
lld()  { __ll_dirs 0; }            # normal dirs only
llf()  { __ll_files 0; }           # normal files only
ll()   { lld; llf; }               # dirs first, then files

llad() { __ll_dirs 1; }            # dot+normal dirs
llaf() { __ll_files 1; }           # dot+normal files
lla()  { llad; llaf; }             # dot+normal dirs, then files
