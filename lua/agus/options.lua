local vim = vim

vim.g.mapleader = ' '

vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true

vim.opt.mouse = ''

vim.o.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldenable = true

-- Autoformat on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

