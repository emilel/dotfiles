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
        command = 'nmap <silent> <space>r :let @+ = \'include("\' . expand(\'%:p\') . \'")\'<cr>',
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
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.jl*',
        command = 'nnoremap <space>z <cmd>JuliaFormatterFormat<cr>',
        group = julia_group
    }
)

-- tex
local tex_group = vim.api.nvim_create_augroup(
    'tex',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.tex*',
        command = 'nnoremap <buffer> <space>. :exec "!pdflatex %"<cr>:exec "!bibtex " . expand("%:t:r")<cr>:exec "!pdflatex %"<cr>:exec "!pdflatex %"<cr>',
        group = tex_group
    }
)

-- python
local python_group = vim.api.nvim_create_augroup(
    'python',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <space>z <cmd>Black<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nmap <silent> <space>r :let @+ = \'python \' . fnamemodify(expand("%"), ":~:.")<cr>',
        group = julia_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'setl colorcolumn=89',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'setl textwidth=88',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'vnoremap <silent> <buffer> <space>wp yoprint("<esc>pa: "<esc>A, <esc>pa)<esc>V=V',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'vnoremap <silent> <buffer> <space>wt yoprint("type(<esc>pa): "<esc>A, type(<esc>pa))<esc>V=V',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <silent> <buffer> <space>we iprint(\'\')<esc>hi',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <silent> <buffer> gb <cmd>:s/True/False<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <silent> <buffer> gB <cmd>:s/False/True<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'inoremap <expr> <c-a> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . getcwd())',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap ,dd opdb.set_trace()<esc>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap ,DD mu?pdb.set.trace()<cr>"_dd`u:noh<cr>',
        group = python_group
    }
)
-- yoprint(f"^[pa: {^[pa}")^[
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'vnoremap ,p yoprint(f"<esc>pa: {<esc>pa} {(type(<esc>pa))}") # DEBUG STATEMENT<esc>gv',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap ,P mu/# DEBUG STATEMENT<cr>"_dd`u:noh<cr>',
        group = python_group
    }
)

-- markdown
local markdown_group = vim.api.nvim_create_augroup(
    'markdown',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.md*',
        command = 'nnoremap <space>z mqgggqG`q',
        group = markdown_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.md*',
        command = 'set shiftwidth=2',
        group = markdown_group
    }
)
vim.g.vim_markdown_new_list_item_indent = 2
vim.g.vim_markdown_conceal = 0
