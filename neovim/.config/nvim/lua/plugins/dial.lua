return {
    'monaqa/dial.nvim',
    keys = {
        {
            "<C-a>",
            function()
                require("dial.map").manipulate("increment", "normal")
            end,
            desc = 'Increment'
        },
        {
            "<C-x>",
            function()
                require("dial.map").manipulate("decrement", "normal")
            end,
            desc = 'Decrement'
        },
        {
            "<C-a>",
            function()
                require("dial.map").manipulate("increment", "visual")
            end,
            desc = 'Increment',
            mode = 'x'
        },
        {
            "<C-x>",
            function()
                require("dial.map").manipulate("decrement", "visual")
            end,
            desc = 'Decrement',
            mode = 'x'
        }
    },
    config = function()
        local augend = require("dial.augend")
        require("dial.config").augends:register_group {
            default = {
                augend.integer.alias.decimal_int,
                augend.integer.alias.hex,
                augend.constant.alias.bool,
                augend.constant.new {
                    elements = { "Debug", "Release" },
                },
                augend.constant.new {
                    elements = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" },
                },
                augend.constant.new({
                    elements = { "x86_64-linux-gnu", "xtensa-amd-phoenix" },
                })
            },
        }
    end
}
