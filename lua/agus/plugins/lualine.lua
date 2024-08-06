return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"AndreM222/copilot-lualine",
	},
	opts = {
		theme = "catppuccin",
		sections = {
			lualine_x = { "copilot", "encoding", "fileformat", "filetype" },
		},
	},
}
