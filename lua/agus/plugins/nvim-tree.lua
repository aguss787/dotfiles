return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require("nvim-tree").setup({
      view = {
        side = "right",
      },
      actions = {
        open_file = {
          window_picker = {
            enable = false,
          },
        },
      }
    })

    local api = require("nvim-tree.api")

    vim.keymap.set('n', '<leader>pp', api.tree.focus)
    vim.keymap.set('n', '<leader>pc', api.tree.close)
    vim.keymap.set('n', '<leader>pf', function() 
      api.tree.find_file()
      api.tree.focus()
    end)
  end
}
