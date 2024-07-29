local vim = vim

-- Exit insert mode
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true, silent = true })

-- Window management
vim.keymap.set('n', '<leader>sv', '<cmd>vsp<CR>', {})
vim.keymap.set('n', '<leader>sh', '<cmd>sp<CR>', {})

-- Remove highlight until next searcg
vim.api.nvim_set_keymap('n', '<leader>/', '<cmd>noh<CR>', { noremap = true, silent = true })

-- NvimTree
vim.api.nvim_set_keymap('n', '<leader>pp', '<cmd>NvimTreeFocus<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pc', '<cmd>NvimTreeClose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pf', '<cmd>NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- Quickfix
vim.api.nvim_set_keymap('n', '<leader>qq', '<cmd>copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qc', '<cmd>cclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qf', '<cmd>cfirst<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ql', '<cmd>clast<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qn', '<cmd>cnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qp', '<cmd>cprev<CR>', { noremap = true, silent = true })

local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, {})
vim.keymap.set('n', '<leader>fs', telescope_builtin.git_status, {})

local telescope = require('telescope')
vim.keymap.set('n', '<leader>fa', telescope.extensions.aerial.aerial, {})

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
vim.keymap.set('n', '<leader>ii', vim.lsp.buf.code_action, {})
vim.keymap.set('v', '<leader>ii', vim.lsp.buf.code_action, {})
vim.keymap.set('n', '<leader>ir', vim.lsp.buf.rename, {})
vim.keymap.set('n', '<leader>iq', vim.diagnostic.setqflist, {})
vim.keymap.set('n', '<leader>il', vim.diagnostic.setloclist, {})

-- Aerial
local aerial = require('aerial')
vim.keymap.set('n', '<leader>ac', aerial.close, {})
vim.keymap.set('n', '<leader>aa', aerial.open, {})

-- UFO
local ufo = require('ufo')
vim.keymap.set('n', 'zp', ufo.peekFoldedLinesUnderCursor, {})

-- XdgOpenLog
local xdg_open_log = require('agus.functions.xdg-open-log')
vim.keymap.set('n', '<leader>x', xdg_open_log.xdgOpenLog, {})

-- Comment
local comment = require('Comment.api')
vim.keymap.set('n', '<leader>cc', comment.toggle.linewise.current)
vim.keymap.set(
    'n', '<leader>c', comment.call('toggle.linewise', 'g@'),
    { expr = true }
)

vim.keymap.set('n', '<leader>cbb', comment.toggle.blockwise.current)
vim.keymap.set(
    'n', '<leader>cb', comment.call('toggle.blockwise', 'g@'),
    { expr = true }
)

local esc = vim.api.nvim_replace_termcodes(
  '<ESC>', true, false, true
)

vim.keymap.set('x', '<leader>cc', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    comment.toggle.linewise(vim.fn.visualmode())
end)
vim.keymap.set('x', '<leader>cb', function()
    vim.api.nvim_feedkeys(esc, 'nx', false)
    comment.toggle.blockwise(vim.fn.visualmode())
end)

