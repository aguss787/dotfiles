local constants = {LLM_ROLE = "llm", USER_ROLE = "user", SYSTEM_ROLE = "system"}

return {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", {
            "MeanderingProgrammer/render-markdown.nvim",
            ft = {"markdown", "codecompanion"}
        }, {"OXY2DEV/markview.nvim"}, {
            "ravitemer/mcphub.nvim",
            dependencies = {"nvim-lua/plenary.nvim"},
            build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
            config = function()
                local mcphub = require("mcphub")
                mcphub.setup({
                    auto_approve = true,
                    native_servers = {
                        system_info = {
                            name = "system_info",
                            displayName = "System Info",
                            capabilities = {
                                resources = {
                                    {
                                        name = "cwd",
                                        description = "Current working directory",
                                        uri = "system://cwd",
                                        handler = function(req, res)
                                            if req.uri ~= "system://cwd" then
                                                res:error("Invalid URI: " ..
                                                              req.uri)
                                            end

                                            local cwd = vim.fn.getcwd()
                                            return res:text(cwd)
                                        end
                                    }
                                }
                            }
                        }
                    }
                })
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
        opts = {log_level = "INFO", job_start_delay = 100, submit_delay = 100},
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
            chat = {
                adapter = "gemini_flash",
                tools = {
                    opts = {
                        auto_submit_errors = true,
                        auto_submit_success = true,
                        default_tools = {
                            "use_mcp_tool", "access_mcp_resource", "mcp"
                        }
                    }
                }
            },
            inline = {
                adapter = "gemini_flash",
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
            cmd = {adapter = "gemini_flash"}
        },
        adapters = {
            opts = {show_defaults = false},
            gemini_pro = function()
                return require("codecompanion.adapters").extend("gemini", {
                    name = "gemini_pro",
                    formatted_name = "Gemini Pro",
                    env = {
                        api_key = "cmd:cat ~/.config/codecompanion/gemini.key | tr -d ' \n'"
                    },
                    schema = {model = {default = "gemini-2.5-pro"}}
                })
            end,
            gemini_flash = function()
                return require("codecompanion.adapters").extend("gemini", {
                    name = "gemini_flash",
                    formatted_name = "Gemini Flash",
                    env = {
                        api_key = "cmd:cat ~/.config/codecompanion/gemini.key | tr -d ' \n'"
                    },
                    schema = {model = {default = "gemini-2.5-flash"}}
                })
            end,
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {})
            end
        },
        prompt_library = {
            ["Commit"] = {
                strategy = "workflow",
                description = "Commit changes in the current revision",
                opts = {index = 2, short_name = "commit"},
                prompts = {
                    {
                        {
                            role = constants.USER_ROLE,
                            opts = {auto_submit = true},
                            content = function()
                                vim.g.codecompanion_auto_tool_mode = true
                                return
                                    [[commit changes in the current revision. 
the description should be based on the diff and should be formatted based on convetional commit.
look at the last 25 commits to understand the commit message style.
follow the style of the existing commits.  
working directory is #system://cwd 

I have asked you to commit it, you don't need to ask for permission again]]
                            end
                        }
                    }
                }
            },
            ["Commit Message"] = {
                strategy = "workflow",
                description = "Suggest a commit message based on the diff",
                opts = {index = 3, short_name = "cm"},
                prompts = {
                    {
                        {
                            role = constants.USER_ROLE,
                            opts = {auto_submit = true},
                            content = function()
                                vim.g.codecompanion_auto_tool_mode = true
                                return
                                    [[Suggest a commit message based on the diff. 
The description should be based on the diff and should be formatted based on conventional commit.
look at the last 25 commits to understand the commit message style.
follow the style of the existing commits.  
working directory is #system://cwd
DO NOT COMMIT THE REVISION.]]
                            end
                        }
                    }
                }
            },
            ["Agent"] = {
                strategy = "workflow",
                description = "Use a workflow to repeatedly edit then test code",
                opts = {index = 1, short_name = "a"},
                prompts = {
                    {
                        {
                            name = "Setup Test",
                            role = constants.USER_ROLE,
                            opts = {auto_submit = false},
                            content = function()
                                -- Enable turbo mode!!!
                                vim.g.codecompanion_auto_tool_mode = true

                                local project_root = vim.fn.getcwd()
                                local ai_config_path = project_root ..
                                                           "/.ai.json"
                                local test_cmd = ""

                                local file = io.open(ai_config_path, "r")
                                if file then
                                    local content = file:read("*all")
                                    file:close()
                                    local config_table = vim.fn.json_decode(
                                                             content)
                                    if config_table and config_table.test_cmd then
                                        test_cmd = config_table.test_cmd
                                    end
                                end

                                local steps_content =
                                    [[### Steps to Follow

You are required to write code following the instructions provided below and test the correctness by running the designated test suite. Follow these steps exactly:

1. Understand the context by reading #buffer and other required files using @mcp
2. Plan carefully on how you will fulfill the requirements.
3. Update the code in the project using the @mcp tool
]]

                                local test_steps = ""
                                if test_cmd ~= "" then
                                    test_steps = string.format(
                                                     [[4. Then use the @cmd_runner tool to run the test suite with `%s` (do this after you have updated the code)
5. Make sure you trigger both tools in the same response
]], test_cmd)
                                end

                                return steps_content .. test_steps .. [[

We\'ll repeat this cycle until the requirements is met. Ensure no deviations from these steps.

Hints:
- Always read the file using @mcp tool before making any changes to make sure you edit the file correctly. 
- Use context7 when you have issues with external library

### Instructions

Your instructions here]]
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
                            content = "The tests have failed. Make sure you follow the README and run the test suite again"
                        }
                    }
                }
            }
        },
        display = {
            action_palette = {opts = {show_default_prompt_library = false}}
        }
    },
    keys = {
        {"<leader>fr", "<cmd>CodeCompanionAction<cr>", desc = "Find Files"},
        {"<leader>ra", "<cmd>CodeCompanion /a<cr>", desc = "Agent"},
        {
            "<leader>rr",
            "<cmd>CodeCompanionChat toggle<cr>",
            desc = "Toggle chat"
        }, {
            "<leader>rf",
            "<cmd>CodeCompanionChat gemini_flash<cr>",
            desc = "New Chat (Gemini Flash)"
        }, {
            "<leader>rs",
            "<cmd>CodeCompanionChat gemini_pro<cr>",
            desc = "New Chat (Gemini Pro)"
        }
    }
}

