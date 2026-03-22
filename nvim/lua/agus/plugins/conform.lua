return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			yaml = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			rust = { "rustfmt", lsp_format = "fallback" },
			python = { "black" },
			sh = { "beautysh" },
			markdown = { "prettier" },
			c = { "clang-format" },

			-- TS/React
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
		},
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { lsp_fallback = true, async = false, timeout_ms = 1000 }
		end,
	},
	init = function()
		-- FormatDisable! will set formatting just for this buffer
		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				vim.b.disable_autoformat = true
				vim.notify("Autoformatting disabled for this buffer")
			else
				vim.g.disable_autoformat = true
				vim.notify("Autoformatting disabled")
			end
		end, { desc = "Disable autoformat-on-save", bang = true })
		vim.api.nvim_create_user_command("FormatEnable", function(args)
			if args.bang then
				vim.b.disable_autoformat = false
				vim.notify("Autoformatting enabled for this buffer")
			else
				vim.g.disable_autoformat = false
				vim.notify("Autoformatting enabled")
			end
		end, { desc = "Re-enable autoformat-on-save" })
	end,
}
