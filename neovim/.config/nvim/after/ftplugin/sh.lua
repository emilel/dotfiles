vim.opt_local.formatoptions = "crqanj"
vim.keymap.set('n', '<cr>r', function()
    require('functions.run').send("zsh %")
end, { desc = 'Run in tmux' })
