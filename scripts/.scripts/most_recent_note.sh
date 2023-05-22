#!/bin/sh

cd "$HOME/notes" && ls -t *.md | head -n1 | xargs nvim \
    -c "norm G$" \
    -c "nnoremap <CR><CR> :wq<CR>" && cd -
