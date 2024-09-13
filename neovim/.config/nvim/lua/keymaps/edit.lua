local strings = require('functions.strings')

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

-- don't copy when starting insert mode on a character
vim.keymap.set('n', 's', '"_s', { desc = 'Don\'t copy letter when pressing `s`' })

-- apply normal mode command for every line
vim.keymap.set('x', '<space>:', ':%norm ', { desc = 'Execute normal mode commands on every line' })

-- replace selection on current line
vim.keymap.set('x', 'r',
    '"hymu:s/<C-R>=escape(@h,\'/\\\')<CR>//g | :noh | :normal `u<left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left><left>',
    { desc = 'Replace selection on current line' })

vim.keymap.set('x', 'R', function()
    vim.cmd('normal! "yy')
    local to_replace = strings.escape_vim(vim.fn.getreg('y'))
    vim.api.nvim_feedkeys(':%s/' .. to_replace .. '//gc' .. vim.api.nvim_replace_termcodes('<left><left><left>', true, true, true), 'n', true)
end, { desc = 'Replace selection in file' })
