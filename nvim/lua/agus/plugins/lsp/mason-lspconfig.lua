return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        "mason-org/mason.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp"
    },
    opts = {
        ensure_installed = {
            "lua_ls", "yamlls", "gopls", "pyright", "bashls", "elmls", "clangd"
        }
    }
}

