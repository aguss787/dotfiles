
local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set(
  "n", 
  "<leader>ii", 
  function()
    vim.cmd.RustLsp('codeAction')
  end,
  { silent = true, buffer = bufnr }
)

vim.keymap.set(
  "n", 
  "<leader>if", 
  function()
    vim.cmd.RustFmt()
  end,
  { silent = true, buffer = bufnr }
)

