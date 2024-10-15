local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local marks = require("hl_marks.marks")

local jump_to_hl_mark = function(opts)
  opts = opts or {}

  local mark_infos = marks.get_all_mark_infos()
  if #mark_infos == 0 then
    print("No marks found")
    return
  end

  pickers.new(opts, {
    prompt_title = "Jump to HLMark",
    finder = finders.new_table({
      results = mark_infos
    }),
    sorter = conf.generic_sorter(opts),
    entry_maker = function(entry)
      return {
        value = entry.row_text,
        display = entry.row_text,
        ordinal = entry.row_text,
      }
    end
  }):find()
end

jump_to_hl_mark()
