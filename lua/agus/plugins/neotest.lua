return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter"
  },
  config = function()
    require('neotest').setup({
      adapters = {
        require('rustaceanvim.neotest')
      },
      summary = {
        mappings = {
          target = "T"
        }
      }
    })

    local neotest = require('neotest')
    vim.keymap.set('n', 'tt', neotest.run.run, {})
    vim.keymap.set('n', 'tl', neotest.run.run_last, {})
    vim.keymap.set('n', 'ta', neotest.run.attach, {})
    vim.keymap.set('n', 'to', neotest.output.open, {})
    vim.keymap.set('n', 'tp', neotest.output_panel.toggle, {})
    vim.keymap.set('n', 'ts', neotest.summary.toggle, {})
    vim.keymap.set('n', 'tf', function() neotest.jump.next({ status = 'failed' }) end, {})
    vim.keymap.set('n', 'tF', function() neotest.jump.prev({ status = 'failed' }) end, {})
  end
}
