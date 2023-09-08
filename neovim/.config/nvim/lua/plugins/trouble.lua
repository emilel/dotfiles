return {
    "folke/trouble.nvim",
    lazy = true,
    opts = {
        icons = false
    },
    keys = {
        { '<space>t', '<cmd>TroubleToggle quickfix<cr>', desc = 'Toggle quickfix trouble' },
        { '<space>,dq', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Toggle workplace diagnostics' },
        { '<space>,dd', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Toggle document diagnostics' },
        { '<space>tr', '<cmd>TroubleRefresh<cr>', desc = 'Refresh trouble' },
        {'<c-j>', function () require("trouble").next({skip_groups = false, jump = true}) end, desc = 'Go to next item' },
        {'<c-k>', function () require("trouble").previous({skip_groups = false, jump = true}) end, desc = 'Go to previous item' }
    },
}
