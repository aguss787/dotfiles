return {
	"nvim-tree/nvim-tree.lua",
	opts = {
		view = {
			side = "right",
		},
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},
	},
	keys = {
		{
			"<leader>pp",
			function()
				require("nvim-tree.api").tree.focus()
			end,
			desc = "Focus Project Tree",
		},
		{
			"<leader>pc",
			function()
				require("nvim-tree.api").tree.close()
			end,
			desc = "Close Project Tree",
		},
		{
			"<leader>pf",
			function()
				require("nvim-tree.api").tree.find_file()
				require("nvim-tree.api").tree.focus()
			end,
			desc = "Find File in Project Tree",
		},
	},
}
