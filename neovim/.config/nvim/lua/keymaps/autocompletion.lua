-- trigger autocompletion menu
vim.keymap.set('i', '<c-l>', function()
    if vim.fn.pumvisible() == 1 then
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-y>', true, true, true), 'n', true)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-x><c-o>', true, true, true), 'n', true)
    end
end
, { desc = 'Trigger autocompletion' })
