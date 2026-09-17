#!/bin/zsh

# Pick the clipboard commands (copyr/paster = raw copy/paste) based on the
# display server. The file opener is `open` -> file_open.sh, aliased in
# programs/init_aliases.zsh so it exists whatever the session turns out to be.
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    alias copyr='wl-copy'
    alias paster='wl-paste --no-newline'
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    alias copyr='xclip -selection clipboard'
    alias paster='xclip -selection clipboard -o'
elif grep -qi microsoft /proc/version 2>/dev/null; then
    alias copyr='clip.exe'
    alias paster='powershell.exe -noprofile -command Get-Clipboard'
else
    alias copyr='echo "No clipboard found"'
    alias paster='echo "No clipboard found" >&2'
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
