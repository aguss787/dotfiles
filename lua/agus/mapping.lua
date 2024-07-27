local vim = vim

-- Remove highlight until next searcg
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>noh<CR>', { noremap = true, silent = true })

-- NerdTree
vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>NERDTreeFocus<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>NERDTreeToggle<CR>', { noremap = true, silent = true })

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope.help_tags, {})
vim.keymap.set('n', '<leader>fd', telescope.diagnostics, {})
vim.keymap.set('n', '<leader>fs', telescope.git_status, {})

-- Neotest
local neotest = require('neotest')
vim.keymap.set('n', 'tt', neotest.run.run, {})
vim.keymap.set('n', 'tl', neotest.run.run_last, {})
vim.keymap.set('n', 'ta', neotest.run.attach, {})
vim.keymap.set('n', 'to', neotest.output.open, {})
vim.keymap.set('n', 'tp', neotest.output_panel.toggle, {})
vim.keymap.set('n', 'ts', neotest.summary.toggle, {})
vim.keymap.set('n', 'tf', function() neotest.jump.next({ status = 'failed' }) end, {})
vim.keymap.set('n', 'tF', function() neotest.jump.prev({ status = 'failed' }) end, {})

-- LSP related configs
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', '<C-i><C-i>', vim.lsp.buf.code_action, {})
vim.keymap.set('v', '<C-i>', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<C-i>r', vim.lsp.buf.rename, {})

