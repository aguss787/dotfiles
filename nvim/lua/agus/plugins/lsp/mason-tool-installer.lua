return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	enabled = false,
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		ensure_installed = {
			"stylua",
			"prettier",
			"mypy",
			"black",
			"beautysh",
			"elm-format",
			"clang-format",
		},
	},
}
