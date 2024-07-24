local vim = vim

-- Remove highlight until next searcg
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>noh<CR>', { noremap = true, silent = true })

-- NerdTree
vim.api.nvim_set_keymap('n', '<leader>p', '<cmd>NERDTreeFocus<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>NERDTreeToggle<CR>', { noremap = true, silent = true })

-- Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { noremap = true, silent = true })

-- Neotest
vim.api.nvim_set_keymap('n', 'tt', '<cmd>lua require(\'neotest\').run.run()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tl', '<cmd>lua require(\'neotest\').run.run_last()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ta', '<cmd>lua require(\'neotest\').run.attach()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'to', '<cmd>lua require(\'neotest\').output.open()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tp', '<cmd>lua require(\'neotest\').output_panel.toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'ts', '<cmd>lua require(\'neotest\').summary.toggle()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tf', '<cmd>lua require(\'neotest\').jump.next({ status = \'failed\' })<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'tF', '<cmd>lua require(\'neotest\').jump.prev({ status = \'failed\' })<CR>', { noremap = true, silent = true })

-- LSP related configs
vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-i><C-i>', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<C-i>', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-i>r', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })

-- Possession
vim.api.nvim_set_keymap('n', '<leader>ss', '<cmd>lua require(\'nvim-possession\').list()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sn', '<cmd>lua require(\'nvim-possession\').new()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>su', '<cmd>lua require(\'nvim-possession\').update()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', '<cmd>lua require(\'nvim-possession\').delete()<CR>', { noremap = true, silent = true })
