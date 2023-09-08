# print and copy stdin

copy() {
    text=$(perl -pe 'chomp if eof' </dev/stdin)
    printf $text'\n'
    printf $text | wl-copy
}
