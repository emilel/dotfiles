return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      icons_enabled = false,
      theme = 'jellybeans',
      component_separators = '|',
      section_separators = '',
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        function()
          local filepath = vim.fn.expand('%:p')
          local filename = vim.fn.expand('%:t')
          local parent = vim.fn.fnamemodify(filepath, ':h:t')

          if parent and parent ~= '.' then
            return parent .. '/' .. filename
          else
            return filename
          end
        end,
      },
      lualine_c = { 'branch' },
    }
  },
}
