return {
  'tribela/vim-transparent',
  priority = 1000,
  config = function()
    vim.g.transparent_groups_add = { 
      'NormalFloat', 
      'NvimTreeNormal',
      'StatusLine',
      'StatusLineNC',
    }
  end,
}
