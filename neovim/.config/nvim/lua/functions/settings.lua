local settings = {}

settings.toggle_autoformat = function()
    local current_fo = vim.opt_local.formatoptions:get()

    if current_fo["a"] then
        print('Disabling autoformatting')
        vim.opt_local.formatoptions:remove("a")
    else
        print('Enabling autoformatting')
        vim.opt_local.formatoptions:append("a")
    end
end

return settings
