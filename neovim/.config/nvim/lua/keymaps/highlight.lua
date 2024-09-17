local highlight_positions = {}
local highlights = {}

local colors = {
    '#b8bb26',
    '#83a598',
    '#d3869b',
    '#8ec07c',
    '#fe8019',
    '#ebdbb2',
    '#cc241d',
}

local dark_foreground = '#282828'

for i, color in ipairs(colors) do
    local highlight_name = 'Highlight' .. i
    vim.api.nvim_command('highlight default ' .. highlight_name .. ' guibg=' .. color .. ' guifg=' .. dark_foreground)
    table.insert(highlights, highlight_name)
end

local namespace_id = vim.api.nvim_create_namespace('HighlightNamespace')
local index = 0

local function get_visual_selection_positions()
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    local start_row, start_col = start_pos[2] - 1, start_pos[3] - 1
    local end_row, end_col = end_pos[2] - 1, end_pos[3]

    if start_row > end_row or (start_row == end_row and start_col > end_col) then
        start_row, start_col, end_row, end_col = end_row, end_col - 1, start_row, start_col + 1
    end

    return { start_row, start_col }, { end_row, end_col }
end

local function highlight_selection()
    local current_buf = vim.api.nvim_get_current_buf()
    local start_pos, end_pos = get_visual_selection_positions()

    local start_row, start_col = start_pos[1], start_pos[2]
    local end_row, end_col = end_pos[1], end_pos[2]

    local highlight = highlights[index + 1]
    vim.api.nvim_buf_set_extmark(current_buf, namespace_id, start_row, start_col, {
        end_row = end_row,
        end_col = end_col,
        hl_group = highlight
    })

    table.insert(highlight_positions, {
        start_row = start_row,
        start_col = start_col,
        end_row = end_row,
        end_col = end_col,
        hl_group = highlight
    })

    index = (index + 1) % #highlights

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end

local function jump_to_next_highlight()
    local current_pos = vim.fn.getpos(".")
    local current_row = current_pos[2] - 1
    local current_col = current_pos[3] - 1

    table.sort(highlight_positions, function(a, b)
        if a.start_row == b.start_row then
            return a.start_col < b.start_col
        else
            return a.start_row < b.start_row
        end
    end)

    for _, pos in ipairs(highlight_positions) do
        if pos.start_row > current_row or (pos.start_row == current_row and pos.start_col > current_col) then
            vim.api.nvim_win_set_cursor(0, { pos.start_row + 1, pos.start_col })
            return
        end
    end

    vim.api.nvim_err_writeln("Already on the last highlight.")
end

local function jump_to_prev_highlight()
    local current_pos = vim.fn.getpos(".")
    local current_row = current_pos[2] - 1
    local current_col = current_pos[3] - 1

    table.sort(highlight_positions, function(a, b)
        if a.start_row == b.start_row then
            return a.start_col < b.start_col
        else
            return a.start_row < b.start_row
        end
    end)

    for i = #highlight_positions, 1, -1 do
        local pos = highlight_positions[i]
        if pos.start_row < current_row or (pos.start_row == current_row and pos.start_col < current_col) then
            vim.api.nvim_win_set_cursor(0, { pos.start_row + 1, pos.start_col })
            return
        end
    end

    vim.api.nvim_err_writeln("Already on the first highlight.")
end

local function clear_highlight_under_cursor()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_pos = vim.fn.getpos(".")
    local current_row = current_pos[2] - 1
    local current_col = current_pos[3] - 1
    local updated_highlight_positions = {}

    for i, pos in ipairs(highlight_positions) do
        if current_row >= pos.start_row and current_row <= pos.end_row then
            if (current_row > pos.start_row or current_col >= pos.start_col) and
                (current_row < pos.end_row or current_col < pos.end_col) then
                goto continue
            end
        end
        table.insert(updated_highlight_positions, pos)

        ::continue::
    end

    vim.api.nvim_buf_clear_namespace(current_buf, namespace_id, current_row, current_row + 1)
    for _, pos in ipairs(updated_highlight_positions) do
        vim.api.nvim_buf_set_extmark(current_buf, namespace_id, pos.start_row, pos.start_col, {
            end_row = pos.end_row,
            end_col = pos.end_col,
            hl_group = pos.hl_group
        })
    end

    highlight_positions = updated_highlight_positions
end

local function clear_all_highlights()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(current_buf, namespace_id, 0, -1)
    highlight_positions = {}
end


local function highlight_all_occurrences()
    local current_buf = vim.api.nvim_get_current_buf()
    local start_pos, end_pos = get_visual_selection_positions()
    local start_row, start_col = start_pos[1], start_pos[2]
    local end_row, end_col = end_pos[1], end_pos[2]
    local highlight_text = vim.api.nvim_buf_get_text(current_buf, start_row, start_col, end_row, end_col, {})[1]

    if highlight_text == nil or highlight_text == "" then
        return
    end

    local highlight = highlights[index + 1]
    local search_pattern = vim.pesc(highlight_text)
    local current_line_count = vim.api.nvim_buf_line_count(current_buf)

    for row = 0, current_line_count - 1 do
        local line = vim.api.nvim_buf_get_lines(current_buf, row, row + 1, false)[1]
        for col_start, col_end in line:gmatch('()' .. search_pattern .. '()') do
            local already_highlighted = false
            for _, pos in ipairs(highlight_positions) do
                if pos.start_row == row and pos.start_col == col_start - 1 and
                    pos.end_row == row and pos.end_col == col_end - 1 then
                    already_highlighted = true
                    break
                end
            end

            if not already_highlighted then
                vim.api.nvim_buf_set_extmark(current_buf, namespace_id, row, col_start - 1, {
                    end_row = row,
                    end_col = col_end - 1,
                    hl_group = highlight
                })
                table.insert(highlight_positions, {
                    start_row = row,
                    start_col = col_start - 1,
                    end_row = row,
                    end_col = col_end - 1,
                    hl_group = highlight
                })
            end
        end
    end

    index = (index + 1) % #highlights

    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', true)
end

local function clear_highlights_of_word()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_pos = vim.fn.getpos(".")
    local current_row = current_pos[2] - 1
    local current_col = current_pos[3] - 1

    local word = vim.fn.expand("<cword>")
    if word == "" then
        vim.api.nvim_err_writeln("No word under cursor.")
        return
    end

    local updated_highlight_positions = {}

    for _, pos in ipairs(highlight_positions) do
        local line = vim.api.nvim_buf_get_lines(current_buf, pos.start_row, pos.start_row + 1, false)[1]
        local highlighted_text = line:sub(pos.start_col + 1, pos.end_col)

        if highlighted_text ~= word then
            table.insert(updated_highlight_positions, pos)
        end
    end

    vim.api.nvim_buf_clear_namespace(current_buf, namespace_id, 0, -1)

    for _, pos in ipairs(updated_highlight_positions) do
        vim.api.nvim_buf_set_extmark(current_buf, namespace_id, pos.start_row, pos.start_col, {
            end_row = pos.end_row,
            end_col = pos.end_col,
            hl_group = pos.hl_group
        })
    end

    highlight_positions = updated_highlight_positions
end


vim.keymap.set('x', "'", highlight_selection, { desc = 'Highlight selection' })
vim.keymap.set('n', '<space>n', jump_to_next_highlight, { desc = 'Jump to next highlight' })
vim.keymap.set('n', '<space>N', jump_to_prev_highlight, { desc = 'Jump to previous highlight' })
vim.keymap.set('n', '<space><c-l>', clear_all_highlights, { desc = 'Clear all highlights' })
vim.keymap.set('n', '<space>x', clear_highlight_under_cursor, { desc = 'Clear highlight under cursor' })
vim.keymap.set('n', '<space>X', clear_highlights_of_word, { desc = 'Clear all highlights of word under cursor' })
vim.keymap.set('x', '<space>\'', highlight_all_occurrences, { desc = 'Highlight all occurrences' })
