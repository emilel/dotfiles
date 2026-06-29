#!/bin/zsh

# Pick the clipboard command (copyr = "copy raw") and the file opener based on
# the display server.
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    alias copyr='wl-copy'
    open() {
        command open "$@" >/dev/null 2>&1 &disown
    }
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    alias copyr='xclip -selection clipboard'
    open() {
        command open "$@" >/dev/null 2>&1 &disown
    }
elif grep -qi microsoft /proc/version 2>/dev/null; then
    alias copyr='clip.exe'
    open() {
        explorer.exe "$@"
    }
else
    alias copyr='echo "No clipboard found"'
fi

# Echo stdin and copy it to the clipboard (trailing newline stripped).
copy() {
    local text
    text=$(perl -pe 'chomp if eof' </dev/stdin)
    printf "%s\n" "$text"
    printf "%s" "$text" | copyr
}

# Run a command, print "> cmd args" plus its output, and copy that block.
copyc() {
    local command="$1"
    shift
    local output
    output=$("$command" "$@" 2>&1 | perl -pe 'chomp if eof')
    printf "> %s %s\n\n%s" "$command" "$*" "$output" | copyr
    printf "%s\n" "$output"
}
