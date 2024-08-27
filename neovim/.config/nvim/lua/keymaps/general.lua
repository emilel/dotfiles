-- save file
vim.keymap.set('n', '<c-space>', '<cmd>write<cr>', { desc = 'Save file' })

-- close buffer
vim.keymap.set('n', '<space>c', '<cmd>bd<cr>', { desc = 'Close buffer' })

-- close other windows
vim.keymap.set('n', '<space>F>', '<cmd>only<cr>', { desc = 'Close other windows' })

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
  search_term = vim.fn.escape(search_term, '\\\\')
  vim.o.hlsearch = true
  vim.fn.setreg('/', search_term)
end, { desc = "Don't jump when pressing star" })

-- edit search register
vim.keymap.set('n', '?', function()
  local search_term = vim.fn.getreg('/')
  vim.api.nvim_feedkeys('/' .. search_term, 'n', false)
end, { desc = 'Edit search' })

-- horizontal scroll
vim.keymap.set('n', 'H', 'zH', { desc = 'Scroll to the left' })
vim.keymap.set('n', 'L', 'zL', { desc = 'Scroll to the right' })

-- make full screen
vim.keymap.set('n', '<c-q>', '<cmd>only<cr>', { desc = 'Make full screen' })
