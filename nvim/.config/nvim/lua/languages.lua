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

-- tex
local tex_group = vim.api.nvim_create_augroup(
    'tex',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.tex*',
        command = 'nnoremap <buffer> <space>> :exec "!pdflatex %"<cr>:exec "!bibtex " . expand("%:t:r")<cr>:exec "!pdflatex %"<cr>:exec "!pdflatex %"<cr>',
        group = tex_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.tex*',
        command = 'nnoremap <buffer> <space>. :exec "!pdflatex %"<cr>',
        group = tex_group
    }
)

-- python
local python_group = vim.api.nvim_create_augroup(
    'python',
    { clear = true }
)
-- vim.api.nvim_create_autocmd(
--     'BufEnter',
--     {
--         pattern = '*.py*',
--         command = 'nnoremap <silent> <cr> <cmd>lua require("toggle").Toggle(false)<cr>',
--         group = python_group
--     }
-- )
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <silent> <space><cr> <cmd>lua require("toggle").Toggle(true)<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <space>z <cmd>Black<cr><cmd>Isort<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nmap <silent> <space>r :let @+ = \'py ./\' . fnamemodify(expand("%"), ":~:.")<cr>',
        group = julia_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nmap <silent> <space>R :let @+ = \'py -i ./\' . fnamemodify(expand("%"), ":~:.")<cr>',
        group = julia_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'setl colorcolumn=81',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'setl textwidth=80',
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
        command = 'inoremap <expr> <c-a> fzf#vim#complete("fd <Bar> xargs realpath --relative-to " . getcwd())',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap ,dd opdb.set_trace()<esc>ggoimport pdb<esc><c-o>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap ,DD <cmd>g/\\(pdb\\.set_trace\\\\|import pdb\\)/d<cr><cmd>noh<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'vnoremap ,p y:set textwidth=0<cr>oprint(f"<esc>pa: {<esc>pa} ({type(<esc>pa)})")  # DEBUG STATEMENT<esc>:set textwidth=120<cr>V',
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
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <silent> <space>t muA  # DEBUG: temporary statement<esc>`u',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'nnoremap <silent> <space>T mu/# DEBUG: temporary statement<cr>"_dd`u:noh<cr>',
        group = python_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.py*',
        command = 'set conceallevel=1',
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
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.md*',
        command = 'set conceallevel=0',
        group = markdown_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.md*',
        command = 'nnoremap <silent> <space>. :silent exec "!pandoc % -o " . expand("%:t:r") . ".pdf"<cr>',
        group = markdown_group
    }
)
vim.g.vim_markdown_new_list_item_indent = 2
vim.g.vim_markdown_conceal = 0

-- JSON
local json_group = vim.api.nvim_create_augroup(
    'json',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.js*',
        command = 'set conceallevel=0',
        group = json_group
    }
)

-- bibtex
local bibtex_group = vim.api.nvim_create_augroup(
    'bibtex',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.bib*',
        command = 'set colorcolumn=0',
        group = json_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.bib*',
        command = 'set textwidth=0',
        group = json_group
    }
)

-- bibtex
local text_group = vim.api.nvim_create_augroup(
    'text',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.txt*',
        command = 'set nosmartindent',
        group = text_group
    }
)

-- golang
local go_group = vim.api.nvim_create_augroup(
    'go',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.go*',
        command = 'set noexpandtab',
        group = go_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.go*',
        command = 'nmap <silent> <space>r :let @+ = \'go run \' . fnamemodify(expand("%"), ":~:.")<cr>',
        group = go_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.go*',
        command = 'nnoremap <space>z <cmd>GoFmt<cr><cmd>GoImports<cr>',
        group = go_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.go*',
        command = 'set colorcolumn=0',
        group = go_group
    }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.go*',
        command = 'set textwidth=0',
        group = go_group
    }
)

-- shell
local shell_group = vim.api.nvim_create_augroup(
    'shell',
    { clear = true }
)
vim.api.nvim_create_autocmd(
    'BufEnter',
    {
        pattern = '*.sh*',
        command = 'nmap <silent> <space>r :let @+ = \'./\' . fnamemodify(expand("%"), ":~:.")<cr>',
        group = shell_group
    }
)
