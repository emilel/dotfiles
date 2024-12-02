#!/bin/zsh

# print directory content
catdir() {
  dir=$1
  pattern=${2:-*}
  find "$dir" -type f -name "$pattern" | while read -r file; do
      mime_type=$(file --mime-type -b "$file")
      if [[ "$mime_type" == application/* ]]; then
          continue
      fi
      echo "$file:"
      echo "\`\`\`"
      cat "$file"
      echo "\`\`\`"
      echo
  done
}

# edit stdin/stdout
edit() {
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' EXIT
    cat - > "$tmpfile"
    nvim +"Pipe $tmpfile" < /dev/tty > /dev/tty
    cat "$tmpfile"
}

# edit environment variables
edit_env() {
    local tmpfile=$(mktemp)
    printenv > "$tmpfile"
    nvim "$tmpfile"
    while IFS= read -r line; do
        if [[ -n "$line" && "$line" != \#* ]]; then
            local key=${line%%=*}
            local value=${line#*=}
            export "$key"="$value"
        fi
    done < "$tmpfile"
    rm "$tmpfile"
}

# add to path
atp() {
  path_to_add=$(realpath "$1")
  export PATH="$PATH:$path_to_add"
}

# edit path
edit_path() {
    local tmpfile=$(mktemp)
    print -l "${(@s/:/)PATH}" > "$tmpfile"
    nvim "$tmpfile"
    local new_path=""
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            new_path+="$line:"
        fi
    done < "$tmpfile"
    export PATH="${new_path%:}"
    rm "$tmpfile"
}
