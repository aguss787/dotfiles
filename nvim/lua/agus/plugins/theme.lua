return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		vim.cmd.colorscheme("catppuccin-mocha")

		require("catppuccin").setup({
			integrations = {
				aerial = true,
				cmp = true,
				mason = true,
				dap = true,
				dap_ui = true,
				nvimtree = true,
				treesitter = true,
				neotest = true,
				ufo = true,
				telescope = true,
				lsp_trouble = true,
				illuminate = {
					enabled = true,
					lsp = true,
				},
				which_key = true,
				native_lsp = {
					enabled = true,
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},
			},
		})
	end,
}
