#!/bin/zsh

# edit stdin in neovim (an empty buffer without a pipe); <cr><cr> saves and
# quits, then the result is printed *and* lands in the clipboard. :cq throws
# it away. An argument sets the filetype: `jq . x | edit json`.
edit() {
    local tmpfile
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' EXIT
    [ -t 0 ] || cat >"$tmpfile"
    # zsh fills $TTY in whenever the shell has a terminal; without one nvim
    # couldn't run anyway (and the stubbed tests are glad it's overridable)
    nvim +"Pipe $tmpfile" ${1:+"+setfiletype $1"} <"${TTY:-/dev/null}" >"${TTY:-/dev/null}" || return
    copy <"$tmpfile"
}

# same round trip for the clipboard: paste -> edit -> copy back (and print)
clip() {
    paster | edit "$@"
}

# cat a file inside a fenced code block, tagged with its language (for pasting
# into chat/markdown). Accepts multiple files.
dog() {
    local file lang ext lastchar

    for file in "$@"; do
        if [[ ! -e "$file" ]]; then
            print -u2 -- "dog: no such file: $file"
            continue
        fi

        if [[ ! -f "$file" ]]; then
            print -u2 -- "dog: not a regular file: $file"
            continue
        fi

        lang=""
        ext="${file:e}"

        case "$ext" in
            py) lang="python" ;;
            sh) lang="bash" ;;
            zsh) lang="zsh" ;;
            js) lang="javascript" ;;
            ts) lang="typescript" ;;
            rs) lang="rust" ;;
            go) lang="go" ;;
            java) lang="java" ;;
            c) lang="c" ;;
            h) lang="c" ;;
            cpp | cc | cxx | hpp) lang="cpp" ;;
            lua) lang="lua" ;;
            json) lang="json" ;;
            yml | yaml) lang="yaml" ;;
            toml) lang="toml" ;;
            md) lang="markdown" ;;
            html) lang="html" ;;
            css) lang="css" ;;
            sql) lang="sql" ;;
        esac

        print -- "${file}:"
        print -- "\`\`\`${lang}"
        command cat -- "$file"

        lastchar=$(tail -c 1 -- "$file" 2>/dev/null)
        [[ "$lastchar" == $'\n' ]] || print

        print -- "\`\`\`"
        print
    done
}
