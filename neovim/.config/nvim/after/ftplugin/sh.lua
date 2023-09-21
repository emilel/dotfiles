vim.opt_local.formatoptions = require('globals').formatoptions
vim.keymap.set('n', '<cr>r', function()
    require('functions.run').send("zsh %")
end, { desc = 'Run in tmux' })
