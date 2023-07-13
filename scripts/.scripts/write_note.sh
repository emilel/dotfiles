#!/bin/sh

noteFilename="$HOME/notes/$(date +%Y-%m-%d).md"

cd "$HOME/notes" && nvim  -c "nnoremap <CR><CR> :wq<CR>" \
  -c 'lua require("harpoon.mark").add_file()' \
  -c "nnoremap q :q<cr>" \
  -c "startinsert" \
  $noteFilename && cd -
