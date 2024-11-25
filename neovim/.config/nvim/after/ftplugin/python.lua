vim.keymap.set('n', '\\st', 'o__import__("ipdb").set_trace()<esc>', { buffer = true, desc = 'Set trace' })
vim.keymap.set('n', '\\e', 'o__import__("sys").exit(-1)<esc>', { buffer = true, desc = 'Exit' })
