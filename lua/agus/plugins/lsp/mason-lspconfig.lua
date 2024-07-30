return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"yamlls",
		},
		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				})
			end,
		},
	},
}
