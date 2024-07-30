-- Exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Window management
vim.keymap.set("n", "<leader>we", "<C-w>=", { desc = "Equalize windows" })
vim.keymap.set("n", "<leader>wj", "<C-w>-", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>wk", "<C-w>+", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>wh", "<C-w><", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader>wl", "<C-w>>", { desc = "Decrease window height" })

-- Split management
vim.keymap.set("n", "<leader>sv", "<cmd>vsp<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>sh", "<cmd>sp<CR>", { desc = "Split horizontally" })

-- Remove highlight until next searcg
vim.keymap.set("n", "<leader>/", "<cmd>noh<CR>", { desc = "Remove highlight until next search" })

-- Quickfix
vim.keymap.set("n", "<leader>qq", "<cmd>copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
vim.keymap.set("n", "<leader>qf", "<cmd>cfirst<CR>", { desc = "Go to first quickfix" })
vim.keymap.set("n", "<leader>ql", "<cmd>clast<CR>", { desc = "Go to last quickfix" })
vim.keymap.set("n", "<leader>qn", "<cmd>cnext<CR>", { desc = "Go to next quickfix" })
vim.keymap.set("n", "<leader>qp", "<cmd>cprev<CR>", { desc = "Go to previous quickfix" })

-- LSP related configs
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
vim.keymap.set("n", "<leader>ii", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("v", "<leader>ii", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>ir", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>iq", vim.diagnostic.setqflist, { desc = "Set quickfix list from diagnostics" })
vim.keymap.set("n", "<leader>il", vim.diagnostic.setloclist, { desc = "Set location list from diagnostics" })

-- XdgOpenLog
local xdg_open_log = require("agus.functions.xdg-open-log")
vim.keymap.set("n", "<leader>x", xdg_open_log.xdgOpenLog, { desc = "Show last entry of xdg-open.log" })
