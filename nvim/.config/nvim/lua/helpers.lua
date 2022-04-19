local R = {}

function map(mode, shortcut, command, opts)
  opts = opts or { noremap = true, silent = true }
  vim.api.nvim_set_keymap(mode, shortcut, command, opts)
end

function R.nmap(shortcut, command, opts)
  map('n', shortcut, command, opts)
end

function R.imap(shortcut, command, opts)
  map('i', shortcut, command, opts)
end

function R.vmap(shortcut, command, opts)
  map('v', shortcut, command, opts)
end

return R
