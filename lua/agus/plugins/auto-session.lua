return {
	"rmagatti/auto-session",
	lazy = false,
	dependencies = {
		"nvim-telescope/telescope.nvim", -- Only needed if you want to use sesssion lens
	},
	opts = {},
	keys = {
		{
			"<leader>sr",
			function()
				vim.cmd("SessionRestore")
			end,
			desc = "Restore session",
		},
		{
			"<leader>ss",
			function()
				vim.cmd("SessionSave")
			end,
			desc = "Save session",
		},
		{
			"<leader>sd",
			function()
				vim.cmd("SessionDelete")
			end,
			desc = "Delete session",
		},
	},
}
