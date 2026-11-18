#!/bin/sh
# NNN_OPENER, run in the foreground (nnn -c). -e only sends text/* to the
# editor, but plenty of text isn't text/*: JSON, a .lua that file(1) calls
# JavaScript, an empty file. xdg-open hands those to a GUI text editor, so
# anything that isn't binary goes to $EDITOR. SVG and tiny PDFs read as text,
# hence the exceptions. The rest goes to file_open.sh, which detaches the app.
case $(file -bL --mime -- "$1") in
    inode/x-empty*) ;;
    image/* | application/pdf* | *charset=binary)
        exec "$(dirname "$0")/file_open.sh" "$@"
        ;;
esac
exec "${VISUAL:-${EDITOR:-nvim}}" "$@"
