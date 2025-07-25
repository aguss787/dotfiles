return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path", "hrsh7th/cmp-cmdline", "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip"
    },
    config = function()
        local cmp = require("cmp")

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            },
            window = {
                -- completion = cmp.config.window.bordered(),
                -- documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({select = true})
            }),

            sources = cmp.config.sources(
                {{name = "nvim_lsp"}, {name = "vsnip"}}, {{name = "buffer"}})
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({"/", "?"}, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{name = "buffer"}}
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config
                .sources({{name = "path"}}, {{name = "cmdline"}}),
            ---@diagnostic disable-next-line: missing-fields
            matching = {disallow_symbol_nonprefix_matching = false}
        })

        require("lspconfig").helm_ls.setup({})
    end
}
