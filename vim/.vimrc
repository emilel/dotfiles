call plug#begin()
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'tami5/sql.nvim'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'mbbill/undotree'
Plug 'hoob3rt/lualine.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'Yggdroot/indentLine'
Plug 'psf/black'
Plug 'szw/vim-maximizer'
Plug 'puremourning/vimspector'
Plug 'tpope/vim-repeat'
Plug 'junegunn/goyo.vim'
Plug 'mcchrish/nnn.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'kalekundert/vim-coiled-snake'
Plug 'tweekmonster/startuptime.vim'
if has('nvim')
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-frecency.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
end
call plug#end()


" --- MISC ---

" never conceal
set conceallevel=1

" map leader to Space
let mapleader=" "

" update time
set updatetime=100

" dont search in closed folds
set foldopen-=search

" fold according to treesitter
if has ('nvim')
    set foldmethod=expr
    set foldexpr=nvim_treesitter#foldexpr()
else
    set foldmethod=indent
endif

" default to no folding
set foldlevel=99

" allow folding for markdown
let g:markdown_folding = 1

" no escape delay
set timeoutlen=1000 ttimeoutlen=0

" text width
set textwidth=79

" switch buffer without saving
set hidden

" relative number
set relativenumber

" cursor line
set cursorline

" show extra rows below when scrolling
set scrolloff=8

" horizontal scroll instead of word wrap
set nowrap

" scroll horizontally one character at a time
set sidescroll=5

" no swap files
set noswapfile

" case insensitive search
set ic

" no caps - ignore case. one+ cap - case sensitive search
set smartcase

" search immediately searches
set incsearch

" highlight all search pattern matches
" set hlsearch

" dont highlight all search pattern matches
set nohlsearch

" ignore case when autocompleting filenames and directories
set wildignorecase

" allow mouse usage
set mouse=a

" use global clipboard
set clipboard=unnamedplus

" show row number
set number

" autocomplete
set wildmenu
set wildmode=longest,list,full

" x does not copy letter
nnoremap x "_x

" but do copy on X
nnoremap X x

" line at text width
set colorcolumn=80

" one space after periods
set nojoinspaces

" persistent undo
if has("persistent_undo")
   let target_path = expand('~/.vim/undo')

    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

" split directions
set splitright
set splitbelow

" don't know
set path+=**

" ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

" dont screw things up
nnoremap <PageUp> :echo 'hoppsan...'<CR>
nnoremap <PageDown> :echo 'hoppsan...'<CR>
inoremap <PageUp> <Esc>:echo 'hoppsan...'<CR>a
inoremap <PageDown> <Esc>:echo 'hoppsan...'<CR>a


" --- MAPPINGS ---

" clear quickfix list
command! ClearQuickfixList cexpr []
nnoremap <leader>Q <cmd>ClearQuickfixList<cr>

" copy path
command! Path let @+ = expand("%")

" inline paste normal
nnoremap <leader>p a<cr><esc>P`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>kgJgJ

" inline paste visual
vnoremap <leader>p p`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>kgJgJ

" inline paste without copying
vnoremap <leader>P "_di<cr><esc>P`[v`]:'<,'>.!perl -pe "s/^\s*(.*?)\s*$/\1/"<cr>kgJgJ

" escape from visual leads to end
vnoremap <esc> <esc>`>

" y from visual leads to end
vnoremap y y`>

" select pasted text
nnoremap gp `[v`]

" find word in dictionary
imap <c-n> <plug>(fzf-complete-word)

" complete file
imap <c-x><c-f> <plug>(fzf-complete-file)

" complete line
imap <c-x><c-l> <plug>(fzf-complete-line)

" " toggle hlsearch
" let hlstate=0
" nnoremap <silent> <leader>/ :if (hlstate%2 == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=hlstate+1<cr>

" search for visually selected word in file
vnoremap / "hy/\V<C-R>=escape(@h,'/\')<CR><CR>

" show normal mode mappings
nmap <leader><tab> <plug>(fzf-maps-n)

" substitute visually selected word globally
vnoremap <leader>s "hy:g~<C-r>h~s///gc<left><left><left>

" substitute visually selected word on one line
vnoremap s "hy:.,.g~<C-r>h~s///g<left><left>

" go to last change
nnoremap g. `.

" go to end of line
vnoremap L $h

" toggle fold
nnoremap <silent> <CR> za

" record macro in visual
vnoremap <silent> q <esc>qqgv

" toggle fold all
nnoremap <expr> <Backspace> &foldlevel ? 'zM' :'zR'

" switch file
" nnoremap <C-G> :ls<CR>:b<Space>

" reload .vimrc
noremap <F1> :source ~/.vimrc<CR>

" window movement
nnoremap <silent> <leader>h :wincmd h<CR>
nnoremap <silent> <leader>j :wincmd j<CR>
nnoremap <silent> <leader>k :wincmd k<CR>
nnoremap <silent> <leader>l :wincmd l<CR>

" close window
nnoremap <silent> <leader>c :q<CR>

" find placeholder
nnoremap <leader><leader> /(__)<cr>ca)

" close
nnoremap <leader>x :qa<cr>

" tab movement
nnoremap <silent> <leader>o :tabprevious<CR>
nnoremap <silent> <leader>i :tabnext<CR>

" paste without copying
vnoremap P "_dP

" scroll down
map ö <C-e>

" scroll up
map ä <C-y>

" scroll to the right
map Ö zl

" scroll to the left
map Ä zh

" delete line without coyping
" nnoremap dD "_dd

" start error

" delete without copying
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" å is colon
nnoremap å :

" dont yank while pasting to replace
" xnoremap <expr> P '"_d"'.v:register.'P'

" insert latex template
" nnoremap ,latex :read ~/.latex_template.tex<CR>k"_dd17gg

" save file
nnoremap <C-space> :w<CR>
vnoremap <C-space> <esc>:w<CR>

" new tab
nnoremap <leader>T :tabnew<CR>

" navigate quickfix list
nnoremap <silent> <C-j> :cnext<CR>zz
nnoremap <silent> <C-k> :cprev<CR>zz
nnoremap <silent> <leader><C-j> :lnext<CR>zz
nnoremap <silent> <leader><C-k> :lprev<CR>zz

" toggle quickfix list
nnoremap <silent> <C-q> :call ToggleQFList(1)<CR>
nnoremap <silent> <leader>q :call ToggleQFList(0)<CR>

let g:the_primeagen_qf_l = 0
let g:the_primeagen_qf_g = 0

fun! ToggleQFList(global)
    if a:global
        if g:the_primeagen_qf_g == 1
            let g:the_primeagen_qf_g = 0
            cclose
        else
            let g:the_primeagen_qf_g = 1
            copen
        end
    else
        if g:the_primeagen_qf_l == 1
            let g:the_primeagen_qf_l = 0
            lclose
        else
            let g:the_primeagen_qf_l = 1
            lopen
        end
    endif
endfun


" --- REMAPPINGS ---

" make y behave like it should
nnoremap Y y$

" include current character backwards
" nnoremap dF dvF
" nnoremap dT dvT
" nnoremap d0 dv0
" nnoremap d^ dv^
" nnoremap db dvb
" nnoremap dB dvB

" dont jump wildly
" nnoremap n nzzzv
" nnoremap N Nzzzv
" nnoremap J mzJ'z

" undo not everything
inoremap <cr> <c-g>u<cr>
inoremap ) )<c-g>u
inoremap ] ]<c-g>u
inoremap } }<c-g>u

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <c-j> <esc>:m +1<cr>==i
inoremap <c-k> <esc>:m -2<cr>==i
" nnoremap <leader>j :m .+1<cr>==
" nnoremap <leader>k :m .-2<cr>==

" keep visual selection when indenting
vnoremap < <gv
vnoremap > >gv


" --- VISUAL ---

" use dark theme
set background=dark

" always show gutter
if has ('nvim')
    set signcolumn=yes:1
end

" color thingies
set termguicolors


" --- STATUSLINE ---

" show statusline by default
set laststatus=2

" start with empty statusline
set statusline=

" relative file name
set statusline+=\ %f

" read only flag
set statusline+=%r

" whether the file is modified
set statusline+=%m

" git branch
set statusline+=\ [%{fugitive#head()}]

" switch to right side
set statusline+=%=

" current line number/total lines:column
set statusline+=\ %l/%L:%v

" right padding
set statusline+=\ 


" --- TABS, WHITE SPACE AND INDENTATION ---

" detect filetype, indentation
filetype plugin indent on

" width of existing hard tabs
set tabstop=4

" insert spaces when pressing tab
set expandtab

" how many spaces per shift
set shiftwidth=4

" spaces to insert per tab
set softtabstop=4

" automatically indent code
set autoindent

" show whitespace
set list

" show hard tabs and trailing spaces
set listchars=tab:>-,trail:-

" insert hard tab
" inoremap <S-Tab> <C-V><Tab>


" --- FORMATTING OPTIONS (help fo-table) ---

" t - auto wrap using textwidth.
" c - auto wrap comments using textwidth, inserting comment leader
" r - insert comment leader when pressing enter in insert mode
" q - allow formatting of comments with 'gq'
" 2 - when formatting text, follow the second line of a paragraph
" j - remove comment leader when joining lines
" o - dont insert leader when pressing o
let blacklist = ['text']
autocmd vimenter * if index(blacklist, &ft) < 0 | set formatoptions=tcrq2j

" auto format text when typing
autocmd FileType text set formatoptions=tcrq2j


" --- FILETYPES

augroup zsh_edit_command
    autocmd!
    autocmd FileType zsh set wrap
    autocmd FileType zsh set textwidth=0
    autocmd FileType zsh,gitcommit nnoremap <buffer> <CR><CR> :wq<CR>
augroup END

augroup makefiles
    autocmd!
    autocmd FileType makefile setl noexpandtab
augroup END

augroup width
    autocmd!
    autocmd FileType python setl colorcolumn=98
    autocmd FileType python setl textwidth=97
    autocmd FileType gitcommit setl colorcolumn=73
    autocmd FileType gitcommit setl textwidth=72
    autocmd FileType vim,qf,conf,zsh,tmux setl textwidth=0
    autocmd FileType vim,qf,conf,zsh,tmux setl colorcolumn=0
augroup END

augroup conceal
    autocmd!
    autocmd FileType dockerfile,makefile setl conceallevel=0
augroup END

augroup commentstrings
    autocmd!
    autocmd FileType markdown setl commentstring='<!---\ %s\ --->'
augroup END

augroup whitespace
    autocmd!
    autocmd InsertLeave * set list
    autocmd InsertEnter * set nolist
augroup END

augroup break_undo
    autocmd!
    autocmd FileType text,markdown inoremap . .<c-g>u
    autocmd FileType text,markdown inoremap , ,<c-g>u
    autocmd FileType text,markdown inoremap ! !<c-g>u
    autocmd FileType text,markdown inoremap ? ?<c-g>u
augroup END

augroup pythonstuff
    autocmd!
    " print current expression
    autocmd FileType python vnoremap <silent> <buffer> <leader>wp yoprint("<esc>pa: "<esc>A, <esc>pa)<esc>V=V
    " print current expression type
    autocmd FileType python vnoremap <silent> <buffer> <leader>wt yoprint("type(<esc>pa): "<esc>A, type(<esc>pa))<esc>V=V
    " format python file
    autocmd FileType python nnoremap <silent> <buffer> <leader>z :Black<cr>
augroup end


" --- PLUGINS ---

" --- UNDOTREE ---

nnoremap <leader>u :UndotreeToggle<cr>


" --- INDENTLINE ---

"  keep conceallevel
let g:indentLine_setConceal = 0

" indent character
let g:indentLine_char = '▏'

" --- NNN ---

" open file explorer
nnoremap <silent> _ :NnnPicker<CR>

" open file directory in file explorer
nnoremap <silent> - :NnnPicker %:p:h<CR>

" dont use <leader>n as shortcut
let g:nnn#set_default_mappings = 0

" open the picker in a floating window
let g:nnn#layout = { 'window': { 'width': 0.95, 'height': 0.95, 'highlight': 'Debug' } }

" no rollover
let g:nnn#command = 'nnn -R'


" --- FZF ---

" search for files
nnoremap <silent> <leader>a <cmd>Telescope frecency<cr>

" search for open buffers
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>

" open diagnostics for project
nnoremap <silent> <leader>dq <cmd>Telescope lsp_workspace_diagnostics<cr>

" search for file contents
nnoremap <silent> <leader>/ <cmd>Rg!<CR>

" search for visually selected word in project
vnoremap <leader>/ "hy:Rg! <C-r>h<cr>

" don't search for file names when searching for content (duh)
command! -bang -nargs=* Rg
    \ call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
    \ fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" show preview window
let g:fzf_preview_window = 'down:50%'

" completion
imap <silent> <tab> <Plug>(completion_smart_tab)
imap <silent> <s-tab> <Plug>(completion_smart_s_tab)

" 'Set completeopt to have a better completion experience'
set completeopt=menuone,noinsert,noselect

" 'Avoid showing message extra message when using completion'
set shortmess+=c


" --- GRUVBOX ---

" contrast when dark
let g:gruvbox_contrast_dark = 'medium'

" contrast when light
let g:gruvbox_contrast_light = 'hard'

" number column
let g:gruvbox_sign_column = 'bg0'

" apply theme
colorscheme gruvbox


" --- SIGNIFY ---

" let g:signify_sign_add = '++'
" let g:signify_sign_delete  = '__'
" let g:signify_sign_delete_first_line = '‾‾'
" let g:signify_sign_change = '~~'
" let g:signify_priority = 1
" let g:signify_disable_by_default = 1
" hi SignifySignDelete guifg=orange

" nnoremap <leader>q :SignifyToggle<CR>


" --- FUGITIVE ---

" status for adding and committing
nnoremap <leader>gs :Ge :<CR>

" push
nnoremap <leader>gp :Git push<CR>

" checkout
nnoremap <leader>gc :Git checkout<space>

nnoremap <leader>ga :Git<space>

" push new branches
command Pushnew !git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)

" git giff history
command! DiffHistory call s:view_git_history()

function! s:view_git_history() abort
  Git difftool --name-only ! !^@
  call s:diff_current_quickfix_entry()
  " Bind <CR> for current quickfix window to properly set up diff split layout after selecting an item
  " There's probably a better way to map this without changing the window
  copen
  nnoremap <buffer> <CR> <CR><BAR>:call <sid>diff_current_quickfix_entry()<CR>
  wincmd p
endfunction

function s:diff_current_quickfix_entry() abort
  " Cleanup windows
  for window in getwininfo()
    if window.winnr !=? winnr() && bufname(window.bufnr) =~? '^fugitive:'
      exe 'bdelete' window.bufnr
    endif
  endfor
  cc
  call s:add_mappings()
  let qf = getqflist({'context': 0, 'idx': 0})
  if get(qf, 'idx') && type(get(qf, 'context')) == type({}) && type(get(qf.context, 'items')) == type([])
    let diff = get(qf.context.items[qf.idx - 1], 'diff', [])
    echom string(reverse(range(len(diff))))
    for i in reverse(range(len(diff)))
      exe (i ? 'leftabove' : 'rightbelow') 'vert diffsplit' fnameescape(diff[i].filename)
      call s:add_mappings()
    endfor
  endif
endfunction

function! s:add_mappings() abort
  nnoremap <buffer>]q :cnext <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer>[q :cprevious <BAR> :call <sid>diff_current_quickfix_entry()<CR>

  11copen
  wincmd p
endfunction


" --- GOYO
nnoremap <leader>yo :Goyo<CR>

" --- TREESITTER
if has ('nvim')
lua << EOF
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>v",
      node_incremental = ".",
      scope_incremental = ",",
      node_decremental = "-",
    },
  },
  indent = {
      enable = true
  },
  highlight = {
      enable = true,
              -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
endif


" --- VIMSPECTOR ---

fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun

" Debugger remaps
nnoremap <leader>f :MaximizerToggle!<CR>
nnoremap <leader>dbu :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nnoremap <leader>dl <Plug>VimspectorStepInto
nnoremap <leader>dj <Plug>VimspectorStepOver
nnoremap <leader>dk <Plug>VimspectorStepOut
nnoremap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nnoremap <leader>drc <Plug>VimspectorRunToCursor
nnoremap <leader>dbp <Plug>VimspectorToggleBreakpoint
nnoremap <leader>dbc <Plug>VimspectorToggleConditionalBreakpoint

" <Plug>VimspectorStop
" <Plug>VimspectorPause
" <Plug>VimspectorAddFunctionBreakpoint

fun! GotoWindow()
    call win_gotoid(a:id)
    MaximizerToggle
endfun


" --- LSP ---

nnoremap <silent> gd :lua vim.lsp.buf.definition()<cr>
nnoremap <silent> gD :lua vim.lsp.buf.declaration()<cr>
nnoremap <silent> gr :lua vim.lsp.buf.references()<cr>
nnoremap <silent> <leader>eh :lua vim.lsp.buf.hover()<cr>
nnoremap <silent> <leader>rn :lua vim.lsp.buf.rename()<cr>
nnoremap <silent> <leader>N :lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> <leader>n :lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <silent> <leader>el :lua vim.lsp.diagnostic.set_loclist()<cr>
nnoremap <silent> <leader>K :lua vim.lsp.diagnostic.show_line_diagnostics()<cr>
nnoremap <silent> <leader>esh :lua vim.lsp.buf.signature_help()<cr>
nnoremap <silent> <leader>eca :lua vim.lsp.buf.code_action()<cr>
nnoremap <silent> <leader>ei :lua vim.lsp.buf.implementation()<cr>
vnoremap <leader>ef :lua require('refactoring').refactor('Extract Function')<cr>
vnoremap <leader>eF :lua require('refactoring').refactor('Extract Function To File')<cr>

if has ('nvim')
lua << EOF
require'lspconfig'.pyright.setup{on_attach=require'completion'.on_attach}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, { focusable = false }
)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true
    }
)
require('lualine').setup{options = {theme = 'gruvbox'}}
lualine_c = { require('lsp-status').status }

-- not working. hmm
local refactor = require("refactoring")
refactor.setup()
-- end not working. hmm
-- telescope
local actions = require("telescope.actions")
require("telescope").setup({
    defaults = {
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        layout_strategy = "vertical",
        layout_config = {
          vertical = { width = 0.95 }
        },
        mappings = {
            i = {
                ["<C-x>"] = false,
                ["<C-q>"] = actions.send_to_qflist,
            },
        },
    },
    extensions = {
        frecency = {
            show_scores = false,
            show_unindexed = true,
            ignore_patterns = {"*.git/*", "*/tmp/*"},
            disable_devicons = true,
        }
    },
})
require("telescope").load_extension("frecency")
EOF
endif
