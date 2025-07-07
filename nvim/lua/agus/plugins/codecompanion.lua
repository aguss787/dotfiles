local constants = {LLM_ROLE = "llm", USER_ROLE = "user", SYSTEM_ROLE = "system"}
local commit_system_prompt =
    [[You will commit the code changes for the user. Follow these rules:

- You never ask the user for information
- You should get all the necessary information from the mcp servers
- You should understand that the working directory is #system://cwd
- You have strong bias towards using conventional commit
- You should try to replicate the existing commit style as much as possible. You should look at the last 25 commit using mcp to understand the user style
  - if the repository is a Jujutsu (jj) repository:
    - use revision '..@' to for the log message
    - use builtin_log_detailed as the template
- You should make the title and body as clear and simple as possible. You should look at the project diff using mcp to understand what changes
- You should add both title and body 
- You commit the changes using the commit message if the user asked for it
]]

--- @class AiConfig
--- @field test_cmd string? command to run the test suite

-- Helper function to read and parse JSON config
--- @param file_path string
--- @return AiConfig
local function read_ai_config(file_path)
    local file = io.open(file_path, "r")
    if file then
        local content = file:read("*all")
        file:close()
        local success, config_table = pcall(vim.fn.json_decode, content)
        if success and config_table then return config_table end
    end
    return {}
end

-- Function to get merged AI config from home and project directories
--- @return AiConfig
local function get_merged_ai_config()
    -- Read from both home and project .ai.json files
    local home_dir = os.getenv("HOME") or ""
    local project_root = vim.fn.getcwd()

    local home_config_path = home_dir .. "/.ai.json"
    local project_config_path = project_root .. "/.ai.json"

    -- Read home config first (as base)
    local config = read_ai_config(home_config_path)

    -- Read project config and merge (project overrides home)
    local project_config = read_ai_config(project_config_path)
    for key, value in pairs(project_config) do config[key] = value end

    return config
end

return {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
        "folke/noice.nvim", "OXY2DEV/markview.nvim", {
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
        }
    },
    init = function()
        require("agus.functions.codecompanion-notification").init()
    end,
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
                adapter = "claude",
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
                adapter = "claude",
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
            cmd = {adapter = "claude"}
        },
        adapters = {
            opts = {show_defaults = false},
            claude = function()
                return require("codecompanion.adapters").extend("anthropic", {
                    name = "claude",
                    formatted_name = "Claude",
                    env = {
                        api_key = "cmd:cat ~/.config/codecompanion/anthropic.key | tr -d ' \n'"
                    },
                    schema = {
                        model = {default = "claude-sonnet-4-20250514"},
                        extended_thinking = {default = false}
                    }
                })
            end,
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
            end
        },
        prompt_library = {
            ["Commit"] = {
                adapter = "gemini_flash",
                strategy = "chat",
                description = "Commit changes in the current revision",
                opts = {
                    index = 2,
                    short_name = "c",
                    auto_submit = true,
                    user_prompt = false
                },
                prompts = {
                    {
                        role = constants.USER_ROLE,
                        content = function()
                            vim.g.codecompanion_auto_tool_mode = true
                            return commit_system_prompt ..
                                       [[commit changes in the current revision. 

I have asked you to commit it, you don't need to ask for permission again]]
                        end
                    }
                }
            },
            ["Commit Message"] = {
                adapter = "gemini_flash",
                strategy = "chat",
                description = "Suggest a commit message based on the diff",
                opts = {
                    index = 3,
                    short_name = "cm",
                    auto_submit = true,
                    user_prompt = false
                },
                prompts = {
                    {
                        role = constants.SYSTEM_ROLE,
                        content = commit_system_prompt,
                        opts = {visible = false}
                    }, {
                        role = constants.USER_ROLE,
                        content = commit_system_prompt ..
                            "Suggent a commit message based on the diff. DO NOT COMMIT THE REVISION."
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

                                -- Get merged AI config
                                local config = get_merged_ai_config()

                                -- Extract test_cmd with fallback
                                local test_cmd = config.test_cmd or ""

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
            action_palette = {opts = {show_default_prompt_library = false}},
            chat = {show_settings = true, show_tool_processing = true},
            diff = {enabled = true}
        }
    },
    keys = {
        {"<leader>fr", "<cmd>CodeCompanionAction<cr>", desc = "Find Files"},
        {"<leader>ra", "<cmd>CodeCompanion /a<cr>", desc = "Agent"},
        {"<leader>rC", "<cmd>CodeCompanion /c<cr>", desc = "Commit"},
        {
            "<leader>rc",
            "<cmd>CodeCompanion /cm<cr>",
            desc = "Suggest commit message"
        },
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
        }, {
            "<leader>rA",
            function()
                local config = require("codecompanion.config")
                local original_prompt = config.config.prompt_library["Agent"]
                local prompt = vim.deepcopy(original_prompt)
                prompt.adapter = "claude"

                require("codecompanion").prompt_library(prompt, {})
            end,
            desc = "Claude Agent"
        }
    }
}

