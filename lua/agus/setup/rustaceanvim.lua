local vim = vim

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {
		enable_nextest = false
  },
  -- LSP configuration
  server = {
    default_settings = {
      -- rust-analyzer language server configuration
      ['rust-analyzer'] = {
				checkOnSave = {
					command = "clippy"
				},
				inlayHints = {
					maxLength = null
				}
      },
    },
  },
  -- DAP configuration
  dap = {
  },
}
