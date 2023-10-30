# print and copy stdin

copy() {
    text=$(perl -pe 'chomp if eof' </dev/stdin)
    printf $text'\n'
    printf $text | wl-copy
}

awn() {
    if [ -n "$1" ]; then
        echo $1 >> "$HOME/.config/sway/workspace_names"
    else
        echo "Must give an argument!"
    fi
}
