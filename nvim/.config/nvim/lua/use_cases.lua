vim.cmd([[augroup zsh_command
    autocmd!
    autocmd FileType zsh setl wrap
    autocmd FileType zsh setl textwidth=0
    autocmd FileType zsh nnoremap <buffer> <CR><CR> :wq<CR>
augroup END]])

vim.cmd([[augroup git_commit
    autocmd!
    autocmd FileType gitcommit setl colorcolumn=73
    autocmd FileType gitcommit setl textwidth=72
    autocmd FileType gitcommit nnoremap <buffer> <CR><CR> :wq<CR>
augroup END]])
