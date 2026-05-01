return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	branch = "main",
	config = function()
		local treesitter = require("nvim-treesitter")
		treesitter.setup({})
		treesitter.install({ "markdown", "rust", "lua", "python", "yaml", "bash" })
	end,
}
