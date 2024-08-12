local vim = vim

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.expandtab = true

vim.opt.mouse = ""

vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.wrap = false
vim.opt.textwidth = 100
vim.opt.colorcolumn = "+1"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.cursorline = true

-- Use the system clipboard
vim.opt.clipboard:append("unnamedplus")

vim.diagnostic.config({
	virtual_text = true,
})

-- Show line diagnostics automatically in hover window
vim.o.updatetime = 1000
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
