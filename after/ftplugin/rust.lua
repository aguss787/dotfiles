
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n", 
  "<C-i><C-i>", 
  function()
    vim.cmd.RustLsp('codeAction')
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n", 
  "<C-i>f", 
  function()
    vim.cmd.RustFmt()
  end,
  { silent = true, buffer = bufnr }
)

