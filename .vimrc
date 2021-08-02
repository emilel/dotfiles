call plug#begin()
Plug 'tpope/vim-obsession'
Plug 'szw/vim-maximizer'
Plug 'puremourning/vimspector'
Plug 'tpope/vim-repeat'
Plug 'bkad/CamelCaseMotion'
Plug 'junegunn/goyo.vim'
Plug 'mcchrish/nnn.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'kalekundert/vim-coiled-snake'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'
call plug#end()

" --- MISC ---

" map leader to Space
let mapleader = " "

" update time
set updatetime=100

" dont search in closed folds
set foldopen-=search

" fold on indent level
set foldmethod=indent

" default to no folding
set foldlevel=99

" allow folding for markdown
let g:markdown_folding = 1

" no escape delay
set timeoutlen=1000 ttimeoutlen=0

" text width
set textwidth=79

" python files are wide
autocmd FileType python set textwidth=0

" relative number
set relativenumber

" cursor line
set cursorline

" show extra rows below when scrolling
set scrolloff=8

" horizontal scroll instead of word wrap
set nowrap

" scroll horizontally one character at a time
set sidescroll=1

" no swap files
set noswapfile

" case insensitive search
set ic

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

set wildignorecase

" x does not copy letter
noremap x "_x

" line at text width
" set colorcolumn=80

" one space after periods
set nojoinspaces

" netrw
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

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
nmap <PageUp> :echo 'Hoppsan...'<CR>
nmap <PageDown> :echo 'Hoppsan...'<CR>
imap <PageUp> <Esc>:echo 'Hoppsan...'<CR>a
imap <PageDown> <Esc>:echo 'Hoppsan...'<CR>a


" --- MAPPINGS ---

" command window by default
" nnoremap : :<C-F>i

" search for visually selected word
vnoremap / y/\V<C-R>=escape(@",'/\')<CR><CR>

" toggle fold
nnoremap <silent> <CR> za

" toggle fold all
nnoremap <expr> <Backspace> &foldlevel ? 'zM' :'zR'

" switch file
" nmap <C-G> :ls<CR>:b<Space>

" close and save
autocmd FileType zsh nmap <CR><CR> :wq<CR>
" autocmd FileType gitcommit nmap <CR><CR> :wq<CR>
autocmd FileType zsh set wrap
autocmd FileType zsh set textwidth=0

" reload .vimrc
noremap <F1> :source ~/.vimrc<CR>

" window movement
nmap <silent> <leader>h :wincmd h<CR>
nmap <silent> <leader>j :wincmd j<CR>
nmap <silent> <leader>k :wincmd k<CR>
nmap <silent> <leader>l :wincmd l<CR>

" close window
nmap <silent> <leader>c :q<CR>

" close
nnoremap <leader>x :q<ESC>

" tab movement
nmap <silent> <leader>o :tabprevious<CR>
nmap <silent> <leader>i :tabnext<CR>

" paste without copying
vnoremap <leader>p "_dP

" scroll down
map ö <C-e>

" scroll up
map ä <C-y>

" scroll to the right
map Ö zl

" scroll to the left
map Ä zh

" delete line without coyping
" nmap dD "_dd

" start error

" delete without copying
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" å is colon
nmap å :

" " show statusline
map <silent> <F2> :set laststatus=2<CR>

" hide statusline
map <silent> <F3> :set laststatus=1<CR>

" dont yank while pasting to replace
" xnoremap <expr> P '"_d"'.v:register.'P'

" insert latex template
" nmap ,latex :read ~/.latex_template.tex<CR>k"_dd17gg

" save file
nmap <C-space> :w<CR>

" new tab
nmap <leader>T :tabnew<CR>

" navigate quickfix list
nnoremap <silent> <C-j> :cnext<CR>zz
nnoremap <silent> <C-k> :cprev<CR>zz

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

" dont jump wildly
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ'z

" undo not everything
inoremap <cr> <c-g>u<cr>
inoremap . .<c-g>u
inoremap , ,<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
inoremap ) )<c-g>u
inoremap ] ]<c-g>u
inoremap } }<c-g>u

vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '>-2<cr>gv=gv
inoremap <c-j> <esc>:m +1<cr>==i
inoremap <c-k> <esc>:m -2<cr>==i
nnoremap <leader>j :m .+1<cr>==
nnoremap <leader>k :m .-2<cr>==



" --- VISUAL ---

" use dark theme
set background=dark

" always show gutter
set signcolumn=number

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

" obsession status
set statusline+=\ %{ObsessionStatus()}

" switch to right side
set statusline+=%=

function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, 'E' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, 'W' . info['warning'])
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
endfunction

" coc status
set statusline+=\ %{StatusDiagnostic()}

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

" dont show whitespace in insert mode
autocmd InsertLeave * set list
autocmd InsertEnter * set nolist

" show hard tabs and trailing spaces
set listchars=tab:>-,trail:-

" insert hard tab
inoremap <S-Tab> <C-V><Tab>


" --- LANGUAGE SPECIFIC ---

" tabs are two wide in javascript
autocmd FileType javascript setlocal shiftwidth=2 softtabstop=2 tabstop=2


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


" --- PLUGINS ---

" --- OBSESSION ---
nmap <leader>o :Obsession<CR>

" --- DIRVISH ---

"folders first
" let dirvish_mode = ':sort ,^.*/,'
" 
" " open current directory
" nmap <silent> <leader>j :Dirvish<CR>

" camelcasemotion
let g:camelcasemotion_key = '<leader>'

" --- NNN ---

" open file explorer
" nmap <silent> <leader>l :NnnPicker<CR>

" open file directory in file explorer
nmap <silent> - :NnnPicker %:p:h<CR>

" dont use <leader>n as shortcut
let g:nnn#set_default_mappings = 0

" open the picker in a floating window
let g:nnn#layout = { 'window': { 'width': 0.95, 'height': 0.8, 'highlight': 'Debug' } }

let g:nnn#command = 'nnn -R'


" " --- FZF ---
"
" " search for files
nnoremap <silent> <leader>a :Files<CR>

" search for open buffers
nnoremap <silent> <leader>s :Buffers<CR>
"
" " search for file contents
nnoremap <silent> <leader>v :Rg!<CR>

" show preview window
let g:fzf_preview_window = 'down:50%'



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

" nmap <leader>q :SignifyToggle<CR>


"  --- COC ---

" Give more space for displaying messages.
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" go to next problem
nmap <leader>n <Plug>(coc-diagnostic-next)
" nmap <leader>p <Plug>(coc-diagnostic-prev)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <silent> <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
nmap <silent> <leader>z :call CocAction('format')<CR>:CocCommand python.sortImports<CR>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
" xmap <leader>ac  <Plug>(coc-codeaction-selected)
" nmap <leader>ac  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
" nmap <leader>ca  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{StatusDiagnostic()}

" Mappings for CoCList
" Show all diagnostics.
" nnoremap <silent><nowait> <leader>d  :<C-u>CocList diagnostics<cr>
" Manage extensions.
" nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
" nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
" nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
" nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
" nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
" nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
" nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

" folded
if has ('nvim')
    hi Folded ctermfg=223 guifg=fg2
end

" --- FUGITIVE ---

" status for adding and committing
nmap <leader>gs :Ge :<CR>

" take diff currently marked
nmap <leader>gp :diffput<CR>

" checkout
nmap <leader>gc :Git checkout 

" push new branches
command Pushnew !git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)


" --- GOYO
nmap <leader>yo :Goyo<CR>

" --- VIMSPECTOR ---
fun! GotoWindow(id)
    call win_gotoid(a:id)
    MaximizerToggle
endfun

" Debugger remaps
nnoremap <leader>f :MaximizerToggle!<CR>
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dc :call GotoWindow(g:vimspector_session_windows.code)<CR>
nnoremap <leader>dt :call GotoWindow(g:vimspector_session_windows.tagpage)<CR>
nnoremap <leader>dv :call GotoWindow(g:vimspector_session_windows.variables)<CR>
nnoremap <leader>dw :call GotoWindow(g:vimspector_session_windows.watches)<CR>
nnoremap <leader>ds :call GotoWindow(g:vimspector_session_windows.stack_trace)<CR>
nnoremap <leader>do :call GotoWindow(g:vimspector_session_windows.output)<CR>
nnoremap <leader>de :call vimspector#Reset()<CR>

nnoremap <leader>dtcb :call vimspector#CleanLineBreakpoint()<CR>

nmap <leader>dl <Plug>VimspectorStepInto
nmap <leader>dj <Plug>VimspectorStepOver
nmap <leader>dk <Plug>VimspectorStepOut
nmap <leader>d_ <Plug>VimspectorRestart
nnoremap <leader>d<space> :call vimspector#Continue()<CR>

nmap <leader>drc <Plug>VimspectorRunToCursor
nmap <leader>dbp <Plug>VimspectorToggleBreakpoint
nmap <leader>dcbp <Plug>VimspectorToggleConditionalBreakpoint

" <Plug>VimspectorStop
" <Plug>VimspectorPause
" <Plug>VimspectorAddFunctionBreakpoint
