return {
  'stevearc/aerial.nvim',
  dependencies = {
     "nvim-treesitter/nvim-treesitter",
     "nvim-tree/nvim-web-devicons"
  },
  config = function() 
    require("aerial").setup({
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

      attach_mode = "global",
      layout = {
        default_direction = "left",
        placement = "edge",
      },

      lsp = {
        diagnostics_trigger_update = true,
      },

      autojump = true,
      keymaps = {
        ["o"] = "actions.jump"
      }
    });

    local aerial = require('aerial')
    vim.keymap.set('n', '<leader>ac', aerial.close, {})
    vim.keymap.set('n', '<leader>aa', aerial.open, {})

    -- Telescope integration
    local telescope = require('telescope')
    vim.keymap.set('n', '<leader>fa', telescope.extensions.aerial.aerial, {})
  end
}
