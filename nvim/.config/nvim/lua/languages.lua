-- JULIA

local julia_group = vim.api.nvim_create_augroup(
    'julia',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.jl*',
        command = 'setl colorcolumn=93',
        group = julia_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.jl*',
        command = 'setl textwidth=92',
        group = julia_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.jl*',
        command = 'nmap <space>r :let @+ = \'include("\' . expand(\'%:p\') . \'")\'<cr>',
        group = julia_group
    }
)

vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.jl*',
        command = 'inoremap <expr> <c-a> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . expand("%:h"))',
        group = julia_group
    }
)

