vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.topo",
    command = "set filetype=xml",
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.config",
    command = "set filetype=xml",
})
