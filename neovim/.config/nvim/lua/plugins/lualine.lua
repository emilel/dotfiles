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
          local modified = vim.bo.modified and ' [+]' or ''

          if vim.bo.filetype == 'oil' then
            local relative_path = vim.fn.fnamemodify(filepath, ':.')
            return relative_path .. modified
          else
            if parent and parent ~= '.' then
              return parent .. '/' .. filename .. modified
            else
              return filename .. modified
            end
          end
        end,
      },
      lualine_c = { 'branch' },
    }
  },
}
