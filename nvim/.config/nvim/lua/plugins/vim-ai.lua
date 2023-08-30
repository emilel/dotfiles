vim.g.ai_prompts = {
	assistant = [[
>>> system
Act as an assistant to a handsome software developer. You are very helpful and
give correct answers that you are certain about. Every now and then, you give
an inspirational compliment.
]]
	,
	developer = [[
>>> system
You are a software developer with many years of experience. You like clean code
and are an expert at suggesting solutions for code smells. You love type
annotations. Whenever you spot a mistake, you give a very snarky comment about
it, perhaps with an insult. Occasionally you throw in a quote from Borat. All
lines of code are no longer than 80 characters wide, and you don't leave
comments, but you explain the code instead. You only give answers when you are
sure of them, and don't guess or make functions up if they don't actually exist.
]]
	,
	philosopher = [[
>>> system
You are a philosopher from ancient Greece. You end response with a rhetorical
question that really gets you thinking.
]]
	,
	job_application = [[
>>> system
You are a talented writer tasked with helping to improve cover letters. The
cover letters are meant for tech companies, and the writer is a young, newly
graduated person. The goal is to make the reader want to hire this person.
Enthusiasm to learn and help is the most important feature for this person,
but he also has valuable experience. You answer questions. You always comment
on grammatical errors or significant issues with the texts, but you can also
be content with a text that is good enough. If not directly asked for a full
text, you primarily offer advice and tips rather than give full texts.
]]
}

vim.g.ai_role = "assistant"

vim.g.get_current_file = function() return '~/.aichat/' .. vim.g.ai_role end
vim.g.add_suffix = function(path) return path .. '.aichat' end

local function move_file(file)
	local path = vim.g.add_suffix(file)
	local handle = io.popen("stat -c %y " .. path)
	local result
	if handle ~= nil then
		result = handle:read("*a")
		handle:close()
	end
	local _, year, month, day, hour, minute = string.match(result, "(%d%d)(%d%d)-(%d%d)-(%d%d) (%d%d):(%d%d)")
	local creation = day .. '.' .. month .. '.' .. year .. '_' .. hour .. ':' .. minute
	local new_path = vim.g.add_suffix(file .. "-" .. creation)
	local success, err = os.execute("mv " .. path .. " '" .. new_path .. "'")
	if not success then
		print("Error encountered while moving the file:", err)
	end
end

local function set_file()
	local file = vim.g.get_current_file()
	move_file(file)
end

local function create_new_file(path)
	local file = io.open(path, "w")
	if file then
		file:close()
	else
		print("Failed to create a new file at " .. path)
		return
	end
end

vim.g.vim_ai_complete = {
	engine = "complete",
	options = {
		model = "text-davinci-003",
		max_tokens = 1000,
		temperature = 0.1,
		request_timeout = 20,
		selection_boundary = "#####",
	},
	ui = {
		paste_mode = 1,
	},
}

vim.g.vim_ai_edit = {
	engine = "complete",
	options = {
		model = "text-davinci-003",
		max_tokens = 1000,
		temperature = 0.1,
		request_timeout = 20,
		selection_boundary = "#####",
	},
	ui = {
		paste_mode = 1,
	},
}

vim.g.vim_ai_chat = {
	options = {
		model = "gpt-3.5-turbo",
		max_tokens = 1000,
		temperature = 1,
		request_timeout = 20,
		selection_boundary = "",
		initial_prompt = vim.g.ai_prompts[vim.g.ai_role],
	},
	ui = {
		code_syntax_enabled = 1,
		populate_options = 0,
		open_chat_command =
		'execute "edit " . luaeval("vim.g.add_suffix(vim.g.get_current_file())") | set filetype=aichat',
		scratch_buffer_keep_open = 1,
		paste_mode = 0,
	},
}


vim.g.ai_chat_file = vim.g.add_suffix(vim.g.get_current_file())

local function get_roles()
	local roles = {}
	for role, _ in pairs(vim.g.ai_prompts) do
		table.insert(roles, role)
	end

	return roles
end

local function move_old_chat_file()
	local file = vim.g.get_current_file():gsub("~", os.getenv("HOME"))
	move_file(file)
	create_new_file(vim.g.add_suffix(file))
end

local function set_role(role)
	local settings = vim.api.nvim_get_var('vim_ai_chat')
	settings.options.initial_prompt = vim.g.ai_prompts[role]
	vim.api.nvim_set_var('vim_ai_chat', settings)
	vim.g.ai_role = role
	vim.g.ai_chat_file = vim.g.add_suffix(vim.g.get_current_file())
end

return {
	'madox2/vim-ai',
	cmd = {
		"AISetRole",
		"AIChat",
		"AIGetRole",
	},
	keys = {
		{ '<c-w>', ':AI ', mode = 'n', desc = 'Complete with AI' },
		{ '<c-w>', ':AI ', mode = 'v', desc = 'Complete with AI' },
		{ '<space><c-s>', ':execute "AIChat " | w | e #<left><left><left><left><left><left><left><left><left><left><left>', mode = 'n', desc = 'Send prompt to AI' },
		{ '<space><c-s>', ':<c-u>execute "\'<,\'>AIChat " | w | e #<left><left><left><left><left><left><left><left><left><left><left>', mode = 'v', desc = 'Send prompt to AI' },
		{ '<c-s>', ':execute "AIChat " | w<left><left><left><left><left>', mode = 'n', desc = 'Chat with AI' },
		{ '<c-s>', ':<c-u>execute "\'<,\'>AIChat " | w<left><left><left><left><left>', mode = 'v', desc = 'Chat with AI' },
		{ '<c-i>', ':AIEdit ', mode = 'v', desc = 'Edit with AI' },
		{ '<space><c-r>', ':AISetRole ',    desc = 'Set ChatGPT personality' },
		{ '<space><c-n>', ':AIChatNew<cr>:e<cr>', desc = 'Create new AI chat',     silent = true },
		{ '<space><c-g>', ':AIGetRole<cr>', desc = 'Get AI role',     silent = true },
	},
	config = function()
		vim.api.nvim_create_user_command('AISetRole', function(args)
			if vim.tbl_contains(get_roles(), args.args) then
				print("Selected role: " .. args.args)
				set_role(args.args)
			else
				print("Error: " .. args.args .. " is an invalid role")
			end
		end, {
			nargs = 1,
			complete = function(arglead, _, _)
				print(arglead)
				local filtered_roles = {}
				for _, role in ipairs(get_roles()) do
					if string.find(role, arglead) then
						table.insert(filtered_roles, role)
					end
				end
				return filtered_roles
			end,
		})

		vim.api.nvim_create_user_command('AIGetRole', function()
			print(vim.g.ai_role)
		end, {})

		vim.api.nvim_create_user_command('AIGetChatFile', function()
			print(vim.g.ai_chat_file)
		end, {})

		vim.api.nvim_create_user_command('AIChatNew', function()
			move_old_chat_file()
			print("Moved old chat file and started new: " .. vim.g.ai_chat_file)
		end, {})
	end
}
