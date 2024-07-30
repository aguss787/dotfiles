local bufnr = vim.api.nvim_get_current_buf()

vim.keymap.set("n", "<leader>ii", function()
	vim.cmd.RustLsp("codeAction")
end, { buffer = bufnr, desc = "Code action" })

vim.keymap.set("v", "<leader>ii", function()
	vim.cmd.RustLsp("codeAction")
end, { buffer = bufnr, desc = "Code action" })

vim.keymap.set("n", "<leader>if", function()
	vim.cmd.RustFmt()
end, { buffer = bufnr, desc = "Format code" })
