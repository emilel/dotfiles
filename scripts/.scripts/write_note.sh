#!/bin/sh

noteFilename="$HOME/notes/$(date +%Y-%m-%d).md"

if [ ! -f $noteFilename ]; then
  echo "# Anteckningar $(date +%Y-%m-%d)" > $noteFilename
fi

nvim  -c "nnoremap <CR><CR> :wq<CR>" \
  -c 'lua require("harpoon.mark").add_file()' \
  -c "nnoremap q :q<cr>" \
  -c "nnoremap <esc> :q<cr>" \
  -c "norm Go" \
  -c "norm Go## $(date +%H:%M)" \
  -c "norm G2o" \
  -c "norm zz" \
  -c "startinsert" $noteFilename
