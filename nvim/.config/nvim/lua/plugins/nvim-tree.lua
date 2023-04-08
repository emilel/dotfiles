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

return {
  "nvim-tree/nvim-tree.lua",
  keys = {
    { "-", "<cmd>NvimTreeFindFile<cr>", desc = "Toggle file tree" },
  },
  opts = {
    view = {
      width = 40,
      mappings = {
        custom_only = false,
        list = {
          { key = "l",     action = "edit",         action_cb = edit_or_open },
          { key = "L",     action = "preview" },
          { key = "h",     action = "close_node" },
          { key = "H",     action = "collapse_all", action_cb = collapse_all },
          { key = "<esc>", action = "close" }
        }
      },
    },
    actions = {
      open_file = {
        quit_on_open = true
      }
    },
    renderer = {
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true
        }
      },
      add_trailing = true
    },
  },
  version = "*",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
}
