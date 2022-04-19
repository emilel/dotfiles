-- HELPERS
local nmap = require('helpers').nmap
local imap = require('helpers').imap
local vmap = require('helpers').vmap

-- TELESCOPE

require('telescope').setup {
    pickers = {
        find_files = {
            hidden = true
        }
    },
    defaults = {
        file_ignore_patterns = {
            ".git"
        },
        layout_strategy = "vertical",
        mappings = {
            i = {
                ["<C-q>"] = require("telescope.actions").send_to_qflist,
            },
        },
    }
}

-- find file
nmap('<space>a', '<cmd>Telescope find_files<cr>')

-- find buffer
nmap('<space>s', '<cmd>Telescope buffers<cr>')

-- find text
nmap('<space>/', '<cmd>Telescope live_grep<cr>')

-- find selected text
vmap('<space>/', '"hy:lua require("telescope.builtin").grep_string({ search = <C-r>h })<cr>', { noremap = false, silent = false })


-- TREESITTER

-- enable folding via treesitter
vim.opt.foldmethod='expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel=99

require('nvim-treesitter.configs').setup {
    incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = ",v",
          node_incremental = ".",
          scope_incremental = ",",
          node_decremental = "-",
        },
    },
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
    },
    indent = {
      enable = true,
    },
}

-- VIM-COMMENTARY

-- paste block above or below
nmap('gcP', 'muP`[v`]gc`u', { noremap = false, silent = true })
nmap('gcp', 'mup`[v`]gc`u', { noremap = false, silent = true })

-- UNDOTREE

nmap('<space>u', '<cmd>UndotreeToggle<cr>')

--- NNN

-- open folder of current file
nmap('-', '<cmd>NnnPicker %:p:h<cr>')

-- open home folder
nmap('_', '<cmd>NnnPicker<cr>')

-- don't use default mappings
vim.g["nnn#set_default_mappings"] = 0

-- size
vim.g["nnn#layout"] = { window = { width = 0.8, height = 0.80 } }

-- don't rollover
vim.g["nnn#command"] = 'nnn -R'

-- NVIM-CMP
local cmp = require'cmp'
cmp.setup({
mapping = {
  ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
  ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
  ['<C-d>'] = cmp.mapping.scroll_docs(4),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
},
sources = {
  { name = 'nvim_lsp' },
}
})
