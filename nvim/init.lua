require("agus")

-- Conditionally load local configuration if it exists
local local_config = vim.fn.stdpath("config") .. "/lua/local.lua"
local local_init = vim.fn.stdpath("config") .. "/lua/local/init.lua"

if vim.fn.filereadable(local_config) == 1 or vim.fn.filereadable(local_init) == 1 then
	require("local")
end
