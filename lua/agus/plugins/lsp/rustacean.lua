return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	config = function()
		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {
				enable_nextest = true,
			},
			-- LSP configuration
			server = {
				---@diagnostic disable-next-line: unused-local
				on_attach = function(client, bufnr)
					vim.keymap.set("n", "<leader>il", function()
						vim.cmd.RustLsp("codeAction")
					end, { buffer = bufnr, desc = "Code action" })

					vim.keymap.set("v", "<leader>il", function()
						vim.cmd.RustLsp("codeAction")
					end, { buffer = bufnr, desc = "Code action" })

					vim.keymap.set("n", "<leader>if", function()
						vim.cmd.RustFmt()
					end, { buffer = bufnr, desc = "Format code" })

					vim.keymap.set("n", "<leader>or", function()
						vim.cmd.RustLsp("debuggables")
					end, { buffer = bufnr, desc = "Debug" })
				end,
				default_settings = {
					-- Rust-analyzer language server configuration
					["rust-analyzer"] = {
						-- Disable clippy
						checkOnSave = {
							command = "check",
						},
					},
				},
			},
			-- DAP configuration
			dap = {},
		}
	end,
}
