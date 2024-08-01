return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			yaml = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
			python = { "black" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		},
	},
}
