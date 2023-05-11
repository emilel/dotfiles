local ls = require('luasnip')
local t = ls.text_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

ls.config.set_config({
	history = true,
	updateevents = { 'TextChanged', 'TextChangedI' },
	enable_autosnippets = true,
})

vim.keymap.set('n', '<space>sn',
	'<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<cr>', { desc = 'Reload snippets' })

ls.add_snippets("python", {
	s("ternary", {
		i(1, "value"), t(" if "), i(2, "cond"), t(" else "), i(3, "else")
	})
})

ls.add_snippets("go", {
	s(
		"efi",
		fmta(
			[[
<val>, <err> := <f>(<args>)
if <err_same> != nil {
	return <result>, <err_same_2>
}
<finish>
]],
			{
				val = i(1, "value"),
				err = i(2, "err"),
				f = i(3, "function"),
				args = i(4),
				err_same = rep(2),
				err_same_2 = rep(2),
				result = i(5),
				finish = i(0),
				-- result = d(5, go_ret_vals, { 2, 3 }),
			}
		)
	),
})
