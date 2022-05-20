#!/bin/sh

diaryFolder="$HOME/.diary"
noteFolder="$diaryFolder/$(date +%Y)/$(date +%B | tr A-Z a-z)/week_$(date +%V)/$(date +%A | tr A-Z a-z)"
noteFilename="$noteFolder/$(date --iso-8601).md"
mkdir -p $noteFolder

if [ -f $noteFilename ]; then
    printf "\n\n\n" >> $noteFilename
fi

nvim \
  -c "nnoremap <cr><cr> :wq<cr>" \
  -c "norm Gi<!--- $(date --iso-8601=minutes) -->" \
  -c "norm G2o" \
  -c "norm zz" \
  -c "startinsert" $noteFilename
