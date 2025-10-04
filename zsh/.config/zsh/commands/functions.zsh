#!/bin/zsh

# edit stdin/stdout
edit() {
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' EXIT
    cat - > "$tmpfile"
    nvim +"Pipe $tmpfile" < /dev/tty > /dev/tty
    cat "$tmpfile"
}
