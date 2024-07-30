-- Markdown preview
vim.keymap.set("n", "<leader>mp", function()
	vim.cmd("MarkdownPreview")
	print("Markdown preview started")
end, { desc = "Start markdown preview" })

vim.keymap.set("n", "<leader>ms", function()
	vim.cmd("MarkdownPreviewStop")
	print("Markdown preview stopped")
end, { desc = "Stop markdown preview" })
