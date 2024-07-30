vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspMappings", {}),
	callback = function(ev)
		-- enable inlay hints
		if vim.lsp.inlay_hint then
			vim.lsp.inlay_hint.enable(true, { ev.buf })
		end

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = ev.buf, desc = "Go to definition" })
		vim.keymap.set(
			"n",
			"gi",
			"<cmd>Telescope lsp_implementations<CR>",
			{ buffer = ev.buf, desc = "Go to implementation" }
		)
		vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = ev.buf, desc = "Go to references" })

		vim.keymap.set("n", "<leader>ii", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
		vim.keymap.set("v", "<leader>ii", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
		vim.keymap.set("n", "<leader>ir", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })

		-- diagnostics
		vim.keymap.set(
			"n",
			"<leader>dq",
			vim.diagnostic.setqflist,
			{ buffer = ev.buf, desc = "Set quickfix list from diagnostics" }
		)
		vim.keymap.set(
			"n",
			"<leader>dl",
			vim.diagnostic.setloclist,
			{ buffer = ev.buf, desc = "Set location list from diagnostics" }
		)
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to next diagnostic" })
		vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_next, { buffer = ev.buf, desc = "Go to next diagnostic" })
	end,
})
