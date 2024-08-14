return {
	"mfussenegger/nvim-lint",
	event = {
		"BufWritePre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")
		lint.linters_by_ft = {
			python = { "mypy" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			group = vim.api.nvim_create_augroup("Lint", {}),
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>il", function()
			lint.try_lint()
		end, { desc = "Lint" })
	end,
}
