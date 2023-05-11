-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
	-- NOTE: Yes, you can install new plugins here!
	'mfussenegger/nvim-dap',
	-- NOTE: And you can specify dependencies as well
	dependencies = {
		-- Creates a beautiful debugger UI
		'rcarriga/nvim-dap-ui',

		-- Installs the debug adapters for you
		'williamboman/mason.nvim',
		'jay-babu/mason-nvim-dap.nvim',

		-- Add your own debuggers here
		'mfussenegger/nvim-dap-python',
	},
	config = function()
		local dap = require 'dap'
		local dapui = require 'dapui'

		require("mason").setup()
		require('mason-nvim-dap').setup({
			ensure_installed = { 'python' },
			handlers = {
				function(config)
					require('mason-nvim-dap').default_setup(config)
				end,
				python = function(config)
					config.adapters = {
						type = "executable",
						command = "/usr/bin/env",
						args = {
							"python",
							"-m",
							"debugpy.adapter",
						},
					}
					require('mason-nvim-dap').default_setup(config)
				end,
			},
		})

		dap.configurations.python = {
			{
				type = 'python',
				request = 'launch',
				name = "Launch file",
				program = "${file}",
				pythonPath = function()
					return '/usr/bin/python'
				end,
			},
		}

		-- Basic debugging keymaps, feel free to change to your liking!
		vim.keymap.set('n', '<bs>c', dap.continue)
		vim.keymap.set('n', '<bs>l', dap.step_into)
		vim.keymap.set('n', '<bs>j', dap.step_over)
		vim.keymap.set('n', '<bs>k', dap.step_out)
		vim.keymap.set('n', '<bs>b', dap.toggle_breakpoint)
		vim.keymap.set('n', '<bs>B', function()
			dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
		end)

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup {
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
			-- controls = {
			-- 	icons = {
			-- 		pause = '⏸',
			-- 		play = '▶',
			-- 		step_into = '⏎',
			-- 		step_over = '⏭',
			-- 		step_out = '⏮',
			-- 		step_back = 'b',
			-- 		run_last = '▶▶',
			-- 		terminate = '⏹',
			-- 	},
			-- },
		}

		dap.listeners.after.event_initialized['dapui_config'] = dapui.open
		dap.listeners.before.event_terminated['dapui_config'] = dapui.close
		dap.listeners.before.event_exited['dapui_config'] = dapui.close
	end,
}
