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
			"gopls",
			"pyright",
		},
		handlers = {
			function(server_name)
				require("lspconfig")[server_name].setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				})
			end,
			["pyright"] = function()
				require("lspconfig").pyright.setup({
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					filetypes = { "python" },
				})
			end,
			["yamlls"] = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()
				capabilities.textDocument.foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				}

				require("lspconfig").yamlls.setup({
					capabilities = capabilities,
				})
			end,
		},
	},
}
