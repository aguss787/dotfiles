return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim", "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp"
    },
    opts = {
        ensure_installed = {
            "lua_ls", "yamlls", "gopls", "pyright", "bashls", "elmls", "clangd"
        },
        handlers = {
            function(server_name)
                require("lspconfig")[server_name].setup({
                    capabilities = require("cmp_nvim_lsp").default_capabilities()
                })
            end,
            ["cucumber_language_server"] = function()
                local capabilities =
                    require("cmp_nvim_lsp").default_capabilities()

                require("lspconfig").cucumber_language_server.setup({
                    capabilities = capabilities,
                    settings = {
                        cucumber = {
                            glue = {
                                -- Cucumber-JVM
                                "src/test/**/*.java", -- Cucumber-Js
                                "features/**/*.ts", "features/**/*.tsx",
                                "features/**/*.js", "features/**/*.jsx",
                                -- Behat
                                "features/**/*.php", -- Behave
                                "features/**/*.py", -- Pytest-BDD
                                "tests/**/*.py", -- Cucumber Rust
                                "tests/**/*.rs", "features/**/*.rs",
                                -- Cucumber-Ruby
                                "features/**/*.rb", -- SpecFlow
                                "*specs*/**/*.cs", -- Godog
                                "features/**/*_test.go", -- Custom
                                "**/test.rs"
                            }
                        }
                    }
                })
            end,
            ["gopls"] = function()
                local capabilities =
                    require("cmp_nvim_lsp").default_capabilities()

                require("lspconfig").gopls.setup({
                    capabilities = capabilities,
                    settings = {
                        gopls = {
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true
                            }
                        }
                    }
                })
            end,
            ["yamlls"] = function()
                local capabilities =
                    require("cmp_nvim_lsp").default_capabilities()
                capabilities.textDocument.foldingRange = {
                    dynamicRegistration = false,
                    lineFoldingOnly = true
                }

                require("lspconfig").yamlls.setup({capabilities = capabilities})
            end,
            ["rust_analyzer"] = function()
                local capabilities =
                    require("cmp_nvim_lsp").default_capabilities()

                require("lspconfig").rust_analyzer.setup({
                    capabilities = capabilities,
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {features = "all"},
                            -- Disable clippy
                            checkOnSave = {command = "clippy"},
                            inlayHints = {maxLength = 100}
                        }
                    }
                })
            end
        }
    }
}
