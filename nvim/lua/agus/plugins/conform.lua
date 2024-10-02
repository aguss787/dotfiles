return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			yaml = { "prettier" },
			json = { "prettier" },
			lua = { "luaformatter" },
			rust = { "rustfmt", lsp_format = "fallback" },
			python = { "black" },
			sh = { "beautysh" },
			elm = { "elm-format" },
			markdown = { "prettier" },
			c = { "clang-format" },
			cucumber = { "reformat-gherkin" },

			-- TS/React
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
		},
		format_on_save = {
			lsp_fallback = true,
			async = false,
			timeout_ms = 1000,
		},
	},
}
