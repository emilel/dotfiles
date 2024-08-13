local M = {}

M.require_directory = function(directory)
    local dir_path = vim.fn.stdpath('config') .. '/lua/' .. directory
    local files = vim.fn.readdir(dir_path)
    for _, file in ipairs(files) do
        local module_name = directory .. '.' .. file:gsub('%.lua$', '')
        require(module_name)
    end
end

return M
