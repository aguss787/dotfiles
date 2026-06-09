return {
	"folke/todo-comments.nvim",
	lazy = false,
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		keywords = {
			NOCOMMIT = { icon = "", color = "error", alt = { "nocommit" } },
		},
	},
	keys = {
		{ "<leader>ft", "<cmd>TodoTelescope keywords=NOCOMMIT,nocommit<cr>", desc = "NOCOMMIT Telescope" },
		{ "<leader>dt", "<cmd>Trouble todo filter = {tag = {NOCOMMIT}}<cr>", desc = "NOCOMMIT Trouble" },
	},
}
