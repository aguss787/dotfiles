return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>dd",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>dD",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics (Trouble)",
		},
		{
			"<leader>dn",
			"<cmd>Trouble diagnostics next focus=true<cr>",
			desc = "Next (Trouble)",
		},
		{
			"<leader>dp",
			"<cmd>Trouble diagnostics prev focus=true<cr>",
			desc = "Previous (Trouble)",
		},
		{
			"<leader>df",
			"<cmd>Trouble diagnostics first focus=true<cr>",
			desc = "First (Trouble)",
		},
		{
			"<leader>dl",
			"<cmd>Trouble diagnostics last focus=true<cr>",
			desc = "Last (Trouble)",
		},
	},
}
