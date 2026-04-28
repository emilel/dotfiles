local globals = require("globals")

vim.opt_local.conceallevel = globals.conceallevel
vim.opt_local.shiftwidth = 2
vim.opt_local.formatoptions:append("t")

vim.keymap.set("n", "<space>´´", "o```<esc>", { desc = "Insert backticks", buffer = true })
