return {
  'nvim-telescope/telescope.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    require('telescope').setup {
      defaults = {
        file_ignore_patterns = {
          ".git/",
          "target/",
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true,
          }
        }
      }
    }

    local telescope_builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, {})
    vim.keymap.set('n', '<leader>fs', telescope_builtin.git_status, {})
  end
}
