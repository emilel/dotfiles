local path = debug.getinfo(1, "S").source:sub(2)
local dir = path:match("(.*[/\\])"):sub(1, -2)

package.path = dir .. "/?.lua;" .. package.path

for _, filename in ipairs(vim.fn.globpath(dir, "*.lua", false, true)) do
	if filename ~= path then
		local module_name = filename:sub(#dir + 2, -5):gsub("/", ".")
		require(module_name)
	end
end
