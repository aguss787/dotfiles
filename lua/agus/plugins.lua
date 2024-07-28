local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- Theme
Plug('tribela/vim-transparent')
Plug('EdenEast/nightfox.nvim')

Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')

Plug('hrsh7th/vim-vsnip')
Plug('hrsh7th/vim-vsnip-integ')

Plug('stevearc/aerial.nvim')

-- Code completion
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')

-- NeoTest
Plug('antoinemadec/FixCursorHold.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-neotest/nvim-nio')
Plug('nvim-neotest/neotest')

-- Code actions stuff
Plug('RishabhRD/popfix')
Plug('RishabhRD/nvim-lsputils')

-- NerdTree
Plug('preservim/nerdtree')
Plug('Xuyuanp/nerdtree-git-plugin')

-- Tmux integration
Plug('christoomey/vim-tmux-navigator')

-- Git Diff
Plug('mhinz/vim-signify')

-- Markdown preview
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && npx --yes yarn install' })

-- UFO
Plug('kevinhwang91/promise-async')
Plug('kevinhwang91/nvim-ufo')

-- Lua-line
Plug('nvim-lualine/lualine.nvim')
Plug('nvim-tree/nvim-web-devicons')

-- Language Supports
-- Generic
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('github/copilot.vim')

-- Rust
Plug('mfussenegger/nvim-dap')
Plug('rust-lang/rust.vim')
Plug('mrcjkb/rustaceanvim')

-- Helm
Plug('towolf/vim-helm')

vim.call('plug#end')

