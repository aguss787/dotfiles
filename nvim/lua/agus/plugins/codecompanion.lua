local constants = {LLM_ROLE = "llm", USER_ROLE = "user", SYSTEM_ROLE = "system"}

return {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = {"markdown", "codecompanion"}
        }, {
            "OXY2DEV/markview.nvim",
            lazy = false,
            opts = {
                preview = {
                    filetypes = {"markdown", "codecompanion"},
                    ignore_buftypes = {}
                }
            }
        }, {
            "ravitemer/mcphub.nvim",
            dependencies = {"nvim-lua/plenary.nvim"},
            build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
            config = function()
                require("mcphub").setup({auto_approve = true})
            end
        }, {
            "github/copilot.vim",
            enabled = true,
            config = function()
                -- Disable copilot on startup 
                vim.g.copilot_enabled = false
            end
        }
    },
    opts = {
        extensions = {
            mcphub = {
                callback = "mcphub.extensions.codecompanion",
                opts = {
                    make_vars = true,
                    make_slash_commands = true,
                    show_result_in_chat = true
                }
            }
        },
        strategies = {
            -- chat = {adapter = "anthropic"},
            chat = {adapter = "copilot"},
            inline = {
                adapter = "copilotgpt",
                keymaps = {
                    accept_change = {
                        modes = {n = "ga"},
                        description = "Accept the suggested change"
                    },
                    reject_change = {
                        modes = {n = "gr"},
                        description = "Reject the suggested change"
                    }
                }

            },
            cmd = {adapter = "copilotgpt"}
        },
        adapters = {
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {model = {default = "gemini-2.5-pro"}}
                })
            end,
            copilotgpt = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {model = {default = "gpt-4.1"}}
                })
            end
        },
        prompt_library = {
            ["Agent"] = {
                strategy = "workflow",
                description = "Use a workflow to repeatedly edit then test code",
                opts = {index = -999999999, is_default = true, short_name = "a"},
                prompts = {
                    {
                        {
                            name = "Setup Test",
                            role = constants.USER_ROLE,
                            opts = {auto_submit = false},
                            content = function()
                                -- Enable turbo mode!!!
                                vim.g.codecompanion_auto_tool_mode = true

                                return [[### Instructions

Your instructions here

### Steps to Follow

You are required to write code following the instructions provided above and test the correctness by running the designated test suite. Follow these steps exactly:

1. Update the code in #buffer using the @mcp tool
2. Then use the @cmd_runner tool to run the test suite with `cargo fmt && cargo test && cargo clippy -- -D warnings` (do this after you have updated the code)
3. Make sure you trigger both tools in the same response

Always read the file using @mcp tool before making any changes to make sure you edit the file correctly. 
We'll repeat this cycle until the tests pass. Ensure no deviations from these steps.]]
                            end
                        }
                    }, {
                        {
                            name = "Repeat On Failure",
                            role = constants.USER_ROLE,
                            opts = {auto_submit = true},
                            -- Scope this prompt to the cmd_runner tool
                            condition = function()
                                return _G.codecompanion_current_tool ==
                                           "cmd_runner"
                            end,
                            -- Repeat until the tests pass, as indicated by the testing flag
                            -- which the cmd_runner tool sets on the chat buffer
                            repeat_until = function(chat)
                                return chat.tools.flags.testing == true
                            end,
                            content = "The tests have failed. Can you edit the buffer and run the test suite again?"
                        }
                    }
                }
            }
        }
    },
    keys = {
        {"<leader>fr", "<cmd>CodeCompanionAction<cr>", desc = "Find Files"},
        {"<leader>ra", "<cmd>CodeCompanion /a<cr>", desc = "Agent"},
        {
            "<leader>rr",
            "<cmd>CodeCompanionChat toggle<cr>",
            desc = "Toggle chat"
        }
    }
}
