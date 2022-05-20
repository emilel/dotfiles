#!/bin/sh

ls -t ~/notes/*.md | head -n1 | xargs nvim \
    -c "nnoremap <CR><CR> :wq<CR>" \
    -c "nnoremap <esc> :q!<cr>"
