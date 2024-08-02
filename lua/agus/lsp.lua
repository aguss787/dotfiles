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

		-- don't map if the key is already set
		if vim.fn.maparg("<leader>ii", "n") == "" then
			vim.keymap.set("n", "<leader>ii", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
		end

		if vim.fn.maparg("<leader>ii", "v") == "" then
			vim.keymap.set("v", "<leader>ii", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
		end

		if vim.fn.maparg("<leader>ir", "n") == "" then
			vim.keymap.set("n", "<leader>ir", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Format code" })
		end

		if vim.fn.maparg("<leader>if", "n") == "" then
			vim.keymap.set("n", "<leader>if", require("conform").format, { buffer = ev.buf, desc = "Format code" })
		end
	end,
})
