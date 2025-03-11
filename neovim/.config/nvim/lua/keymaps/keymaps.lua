local yank = require('functions.yank')
local strings = require('functions.strings')

-- save file
vim.keymap.set('n', '<c-space>', '<cmd>write<cr>', { desc = 'Save file' })

-- close buffer
vim.keymap.set('n', '<space>w', '<cmd>bd<cr>', { desc = 'Close buffer' })
vim.keymap.set('n', '<space>W', '<cmd>bd!<cr>', { desc = 'Force close buffer' })

-- focus window
vim.keymap.set('n', '<space>h', '<cmd>wincmd h<cr>', { desc = 'Focus window to the left' })
vim.keymap.set('n', '<space>j', '<cmd>wincmd j<cr>', { desc = 'Focus window below' })
vim.keymap.set('n', '<space>k', '<cmd>wincmd k<cr>', { desc = 'Focus window above' })
vim.keymap.set('n', '<space>l', '<cmd>wincmd l<cr>', { desc = 'Focus window to the right' })

-- close Neovim
vim.keymap.set('n', '<space>q', '<cmd>q<cr>', { desc = 'Close Neovim' })
vim.keymap.set('n', '<space>Q', '<cmd>q!<cr>', { desc = 'Force close Neovim' })

-- limit text width
vim.opt.textwidth = 80

-- move cursor
vim.keymap.set('i', '<c-j>', '<down>', { desc = 'Move cursor down' })
vim.keymap.set('i', '<c-k>', '<up>', { desc = 'Move cursor up' })

-- keep visual selection when indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Keep visual selection when indenting' })
vim.keymap.set('v', '>', '>gv', { desc = 'Keep visual selection when indenting' })

-- select line
vim.keymap.set('n', '<space>v', '^v$h', { desc = 'Select line' })

-- select entire file
vim.keymap.set('n', '<space>V', 'gg0VG', { desc = 'Select entire file' })

-- select pasted text
vim.keymap.set('n', 'gp', '`[v`]', { desc = 'Select pasted text' })

-- open quickfix list
vim.keymap.set('n', '<space><c-q>', '<cmd>copen<cr><cmd>wincmd k<cr>', { desc = 'Open quickfix list' })

-- navigate quickfix list
vim.keymap.set('n', '<c-j>', '<cmd>cnext<cr>', { desc = 'Next item in quickfix' })
vim.keymap.set('n', '<c-k>', '<cmd>cprev<cr>', { desc = 'Previous item in quickfix' })

-- don't jump on star
vim.keymap.set('n', '*', function()
  local search_term = vim.fn.expand('<cword>')
  vim.o.hlsearch = true
  vim.fn.setreg('/', '\\<' .. search_term .. '\\>')
end, { desc = "Don't jump when pressing star" })

vim.keymap.set('x', '*', function()
  vim.cmd('normal! "yy')
  local search_term = vim.fn.getreg('y')
  search_term = strings.escape_vim(search_term)

  -- Collect lines
  local lines = {}
  for line in (search_term .. "\n"):gmatch("(.-)\n") do
    -- Trim only leading whitespace on each line
    line = line:gsub("^%s*", "")
    table.insert(lines, line)
  end

  -- If we never had a trailing newline in the original text, we might end up
  -- with an extra empty line at the end — remove it
  if not search_term:match("\n$") and lines[#lines] == "" then
    table.remove(lines)
  end

  -- If there's only one line, no newline was truly intended, so just use that
  if #lines == 1 then
    search_term = lines[1]
  else
    -- Otherwise, we have multiple lines, so join them with \n\s* in between
    -- and allow optional leading whitespace on the first line
    search_term = "\\s*" .. table.concat(lines, "\\n\\s*")
  end

  vim.o.hlsearch = true
  vim.fn.setreg('/', search_term)
end, { desc = "Don't jump when pressing star" })


vim.keymap.set("n", "?", function()
  local input = vim.fn.input("?")
  vim.fn.setreg("/", input)
  vim.cmd("set hlsearch")
end, { desc = "Set search without jumping" })

-- edit search register
vim.keymap.set('n', '<space>?', function()
  local search_term = vim.fn.getreg('/')
  vim.api.nvim_feedkeys('/' .. search_term, 'n', false)
end, { desc = 'Edit search' })

-- append to search
vim.keymap.set('x', '<space>/', function()
  vim.api.nvim_feedkeys('"yy', 'x', false)
  local previous_search = vim.fn.getreg('/')
  local search_term = vim.fn.getreg('y')
  search_term = strings.escape_vim(search_term)
  local new_search = previous_search .. '\\|' .. search_term
  vim.fn.setreg('/', new_search)
end, { desc = 'Append to search' })

-- horizontal scroll
vim.keymap.set('n', 'H', 'zH', { desc = 'Scroll to the left' })
vim.keymap.set('n', 'L', 'zL', { desc = 'Scroll to the right' })

-- make full screen
vim.keymap.set('n', '<c-f>', '<cmd>only<cr>', { desc = 'Make full screen' })

-- toggle fold
vim.keymap.set('n', '<cr>', 'za', { desc = 'Toggle fold' })

-- set filetype
vim.keymap.set('n', '<space>T', ':set filetype=', { desc = 'Set filetype' })

-- keep cursor still after visual mode
vim.keymap.set('x', 'y', 'ygv<esc>', { desc = 'Keep cursor when copying visual selection' })

-- L to go to end of line
vim.keymap.set('x', 'L', '$h', { desc = 'Go to end of line' })

-- open temporary buffer
vim.keymap.set('n', '<space>b', function()
  yank.open_buffer()
  yank.set_exit_keymap('bdelete!')
end, { desc = 'Open temporary buffer' })

-- print current path
vim.api.nvim_set_keymap('n', '<C-t>', '<C-g>', { noremap = true, silent = true })

-- print time of last modification
vim.keymap.set("n", "<space><C-t>", function()
  local file = vim.fn.expand('%')
  print('Last modified: ' .. os.date('%Y-%m-%d %H:%M:%S', vim.fn.getftime(file)) ..
    ', File size: ' .. vim.fn.getfsize(file) .. ' bytes')
end, { noremap = true, silent = true })

-- disable mouse
vim.keymap.set('n', '<space>M', '<cmd>set mouse=<cr>', { desc = 'Disable mouse' })

-- cycle buffers
vim.keymap.set('n', '<tab>', '<cmd>bnext<cr>', { desc = 'Cycle buffers' })
vim.keymap.set('n', '<s-tab>', '<cmd>bprev<cr>', { desc = 'Cycle buffers' })

-- move lines
vim.keymap.set('v', '<c-j>', ':m \'>+1<cr>gv=gv', { desc = 'Move line down' })
vim.keymap.set('v', '<c-k>', ':m \'<-2<cr>gv=gv', { desc = 'Move line up' })

-- add lines
vim.keymap.set('n', '<space>o', 'myo<esc>`y', { desc = 'Add line below' })
vim.keymap.set('n', '<space>O', 'myO<esc>`y', { desc = 'Add line above' })

-- format paragraph length
vim.keymap.set('n', '<space>z', 'mygwap`y', { desc = 'Format paragraph' })

-- don't copy when deleting or changing
vim.keymap.set({ 'n', 'x' }, '<space>d', '"_d', { desc = 'Delete without copying' })
vim.keymap.set({ 'n', 'x' }, '<space>c', '"_c', { desc = 'Change without copying' })
vim.keymap.set({ 'n', 'x' }, 'x', '"_x', { desc = 'Delete without copying' })

-- but do copy on capital x
vim.keymap.set('n', 'X', 'x', { desc = 'Delete without copying' })

-- copy selection and delete line
vim.keymap.set('x', 'D', 'd"_dd', { desc = 'Copy selection and delete line' })

-- don't copy when starting insert mode on a character
vim.keymap.set('n', 's', '"_s', { desc = 'Don\'t copy letter when pressing `s`' })

-- apply normal mode command for every line
vim.keymap.set('x', '<space>:', ':%norm ', { desc = 'Execute normal mode commands on every line' })

-- replace selection on current line
local function replace_selection_on_line()
  vim.cmd('normal! "yy')
  local to_replace = strings.escape_vim(vim.fn.getreg('y'))
  vim.fn.setreg('+', to_replace)

  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(
      'mu:s/<C-R>=escape(@y,\'/\\\')<CR>//g | :noh | :normal `u<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>',
      true, true, true),
    'n', true)
end

-- Map the function to 'r' in visual mode
vim.keymap.set('x', 'r', replace_selection_on_line, {
  desc = 'Replace selection on the current line',
})

local function replace_selection(word_boundaries)
  vim.cmd('normal! "yy')
  local to_replace = strings.escape_vim(vim.fn.getreg('y'))
  local pattern = to_replace

  if word_boundaries then
    pattern = '\\<' .. to_replace .. '\\>'
  end

  vim.api.nvim_feedkeys(
    ':.,$s/' .. pattern .. '/' .. to_replace .. '/gc' ..
    vim.api.nvim_replace_termcodes('<left><left><left>', true, true, true),
    'n', true)
end

-- Replace selection without word boundaries
vim.keymap.set('x', 'R', function()
  replace_selection(false)
end, { desc = 'Replace selection from current line to end of file (no word boundaries)' })

-- Replace selection with word boundaries
vim.keymap.set('x', '<Space>R', function()
  replace_selection(true)
end, { desc = 'Replace selection from current line to end of file (with word boundaries)' })

-- merge with the next line without space in between
vim.keymap.set('n', '<space>J', 'J"_diW', { desc = 'Merge with the next line' })

-- search with word boundaries
vim.keymap.set('n', '</', '/\\<\\><left><left>', { desc = 'Search with word boundaries' })
