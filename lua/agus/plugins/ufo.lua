return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    'kevinhwang91/promise-async',
  },
  event = {
    "BufEnter",
  },
  config = function()
    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
          return {'lsp', 'indent'}
      end
    })

    local ufo = require('ufo')
    vim.keymap.set('n', 'zp', ufo.peekFoldedLinesUnderCursor, {})
  end,
}

