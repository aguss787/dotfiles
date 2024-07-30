-- Exit insert mode
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true, silent = true })

-- Window management
vim.keymap.set('n', '<leader>sv', '<cmd>vsp<CR>', {})
vim.keymap.set('n', '<leader>sh', '<cmd>sp<CR>', {})

-- Remove highlight until next searcg
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>noh<CR>', { noremap = true, silent = true })

-- Quickfix
vim.api.nvim_set_keymap('n', '<leader>qq', '<cmd>copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qc', '<cmd>cclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qf', '<cmd>cfirst<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ql', '<cmd>clast<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qn', '<cmd>cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qp', '<cmd>cprev<CR>', { noremap = true, silent = true })

-- LSP related configs
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', '<leader>ii', vim.lsp.buf.code_action, {})
vim.keymap.set('v', '<leader>ii', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>ir', vim.lsp.buf.rename, {})
vim.keymap.set('n', '<leader>iq', vim.diagnostic.setqflist, {})
vim.keymap.set('n', '<leader>il', vim.diagnostic.setloclist, {})

-- XdgOpenLog
local xdg_open_log = require('agus.functions.xdg-open-log')
vim.keymap.set('n', '<leader>x', xdg_open_log.xdgOpenLog, {})

