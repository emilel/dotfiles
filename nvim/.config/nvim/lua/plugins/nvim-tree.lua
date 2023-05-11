local function collapse_all()
  require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
end

local function edit_or_open()
  -- open as vsplit on current node
  local action = "edit"
  local node = require("nvim-tree.lib").get_node_at_cursor()

  if node == nil then
    return
  end

  -- Just copy what's done normally with vsplit
  if node.link_to and not node.nodes then
    require('nvim-tree.actions.node.open-file').fn(action, node.link_to)
    require("nvim-tree.view").close() -- Close the tree if file was opened
  elseif node.nodes ~= nil then
    require("nvim-tree.lib").expand_or_collapse(node)
  else
    require('nvim-tree.actions.node.open-file').fn(action, node.absolute_path)
    require("nvim-tree.view").close() -- Close the tree if file was opened
  end
end

local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', 'l', api.node.open.edit, { desc = 'Open file', buffer = bufnr })
  vim.keymap.set('n', 'L', api.node.open.preview, { desc = 'Preview file', buffer = bufnr })
  vim.keymap.set('n', 'h', api.tree.collapse_all, { desc = 'Collapse file node', buffer = bufnr })
  vim.keymap.set('n', 'H', api.tree.collapse_all, { desc = 'Collapse directory node', buffer = bufnr })
  vim.keymap.set('n', '<esc>', api.tree.close, { desc = 'Close file tree', buffer = bufnr })
  vim.keymap.set('n', 'q', api.tree.close, { desc = 'Close file tree', buffer = bufnr })
end

return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "-", "<cmd>NvimTreeFindFile<cr>", desc = "Toggle file tree" },
  },
  opts = {
    on_attach = on_attach,
    view = {
      width = 40,
    },
    actions = {
      open_file = {
        quit_on_open = true
      }
    },
    renderer = {
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = false,
          git = false
        }
      },
      add_trailing = true
    },
  },
  version = "*",
  dependencies = {
  },
}
