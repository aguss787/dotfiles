return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

		attach_mode = "global",
		layout = {
			default_direction = "left",
			placement = "edge",
		},

		lsp = {
			diagnostics_trigger_update = true,
		},

		autojump = true,
		keymaps = {
			["o"] = "actions.jump",
		},
	},
	keys = {
		{
			"<leader>ac",
			function()
				require("aerial").close()
			end,
			desc = "Close Aerial",
		},
		{
			"<leader>aa",
			function()
				require("aerial").open()
			end,
			desc = "Open Aerial",
		},
		{
			"<leader>fa",
			function()
				require("telescope").extensions.aerial.aerial()
			end,
			desc = "Find Aerial",
		},
	},
}
