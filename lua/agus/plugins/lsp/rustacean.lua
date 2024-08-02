return {
	"mrcjkb/rustaceanvim",
	version = "^5", -- Recommended
	lazy = false, -- This plugin is already lazy
	config = function()
		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {},
			-- LSP configuration
			server = {
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						-- disable clippy
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
