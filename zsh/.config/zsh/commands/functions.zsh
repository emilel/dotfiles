#!/bin/zsh

# edit stdin/stdout through neovim (filter a pipe)
edit() {
    tmpfile=$(mktemp)
    trap 'rm -f "$tmpfile"' EXIT
    cat - >"$tmpfile"
    nvim +"Pipe $tmpfile" </dev/tty >/dev/tty
    cat "$tmpfile"
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
