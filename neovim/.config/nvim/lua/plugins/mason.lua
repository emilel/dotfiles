-- Installer for LSP servers / tools. Owns its own setup so it can be swapped or
-- reused independently; lsp.lua depends on it. mason prepends its bin to $PATH.
return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	-- Append mason's bin to $PATH so the project's virtualenv tools (prepended at
	-- startup) win, with mason as the fallback.
	opts = { PATH = "append" },
}
