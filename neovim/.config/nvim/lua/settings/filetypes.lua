vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = { "*.topo", "*.config" },
    command = "set filetype=xml",
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.h",
    command = "set filetype=c",
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*/.config/waybar/config",
    command = "set filetype=jsonc"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = { "*.zsh", "*.sh" },
    command = "set filetype=bash"
})

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.inc",
    command = "set filetype=c"
})
