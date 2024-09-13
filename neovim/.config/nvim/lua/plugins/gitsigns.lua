return {
  'lewis6991/gitsigns.nvim',
  config = function()
    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "GitCommit",
    --   callback = function()
    --     require('gitsigns').refresh()
    --   end
    -- })

    require('gitsigns').setup({})
  end
}
