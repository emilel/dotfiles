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
