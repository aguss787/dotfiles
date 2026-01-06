local constants = {LLM_ROLE = "llm", USER_ROLE = "user", SYSTEM_ROLE = "system"}
local commit_system_prompt =
    [[@{cmd_runner} You will commit the code changes for the user. Follow these rules:

- Use `jj` if the repository is a Jujutsu (jj) repository
- Use `jj diff --git` to get the diff
- You never ask the user for information
- You should get all the necessary information from the mcp servers
- You should understand that the working directory is #{system://cwd}
- You have strong bias towards using conventional commit
- You should try to replicate the existing commit style as much as possible. You should look at the last 25 commit using mcp to understand the user style
  - if the repository is a Jujutsu (jj) repository:
    - use revision '..@' to for the log message
    - use builtin_log_detailed as the template
    - use `jj desc`. DO NOT USE `jj commit`
- You should make the title and body as clear and simple as possible. You should look at the project diff using mcp to understand what changes
- You should add both title and body 
- You SHOULD NOT adding reasons for the changes on the commit message. Only add the description of the changes.
  - Example of a good body:
    - "Remove X from enum XYZ"
    - "Add new error reason ABC"
    - "Simplify error handling"
    - "Unify order validation"
  - Example of a bad body:
    - "Add new error error variant ABC to improve error handling"
      - YOU SHOULD NOT ADD REASONS TO THE COMMIT MESSAGE
    - "Unify validation to improva readability"
      - YOU SHOULD NOT ADD REASONS TO THE COMMIT MESSAGE
    - "Remove unused code"
      - It's not clear what's the unused code
    - "Unify order validation"
      - It's not clear what's the validation changed
- You SHOULD NOT using vague words such as "improve", "enhance", "refine" or "update"
  - This is very important because those words doesn't tell the user what the changes are
  - AGAIN, YOU SHOULD NOT USE VAGUE WORDS such as "improve", "enhance", "refine" or "update"
- Use `Add` instead of `Introduce`
- You commit the changes using the commit message if the user asked for it
]]

local code_review_system_prompt =
    [[@{dev} You are a code reviewer. You will review the code and provide feedback.

run `jj diff --git` to get the diff.

You will review the diff and provide feedback.

IMPORTANT:
- You don't glaze the user's code
- You give actionable feedback with concrete suggestions
- You read other files so you understand the context of the code
]]

-- Function to start an agent prompt with a specific adapter
local function start_agent_prompt(adapter)
    local config = require("codecompanion.config")
    local original_prompt = config.config.prompt_library["Agent"]
    local prompt = vim.deepcopy(original_prompt)
    prompt.adapter = adapter

    require("codecompanion").prompt_library(prompt, {})
end

--- @class AiConfig
--- @field test_cmd string? command to run the test suite
--- @field rules string[]? list of rules to pass to the LLM

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

-- Helper function to generate API key command
--- @param service_name string The name of the service (e.g., "anthropic", "gemini", "grok")
--- @return string The command string to read and clean the API key
local function get_api_key_cmd(service_name)
    return string.format(
               "cmd:cat ~/.config/codecompanion/%s.key | tr -d ' \\n'",
               service_name)
end

local function default_system_prompt_func(args)
    -- Determine the user's machine
    local machine = vim.uv.os_uname().sysname
    if machine == "Darwin" then machine = "Mac" end
    if machine:find("Windows") then machine = "Windows" end

    return string.format(
               [[You are an AI programming assistant named "CodeCompanion", working within the Neovim text editor.

You can answer general programming questions and perform the following tasks:
* Answer general programming questions.
* Explain how the code in a Neovim buffer works.
* Review the selected code from a Neovim buffer.
* Generate unit tests for the selected code.
* Propose fixes for problems in the selected code.
* Scaffold code for a new workspace.
* Find relevant code to the user's query.
* Propose fixes for test failures.
* Answer questions about Neovim.

Follow the user's requirements carefully and to the letter.
Use the context and attachments the user provides.
Keep your answers short and impersonal, especially if the user's context is outside your core tasks.
All non-code text responses must be written in the %s language.
Use Markdown formatting in your answers.
Do not use H1 or H2 markdown headers.
When suggesting code changes or new content, use Markdown code blocks.
To start a code block, use 3 backticks.
After the backticks, add the programming language name as the language ID.
To close a code block, use 3 backticks on a new line.
If the code modifies an existing file or should be placed at a specific location, add a line comment with 'filepath:' and the file path.
If you want the user to decide where to place the code, do not add the file path comment.
In the code block, use a line comment with '...existing code...' to indicate code that is already present in the file.
Code block example:
```languageId
// filepath: /path/to/file
// ...existing code...
{ changed code }
// ...existing code...
{ changed code }
// ...existing code...
```
Ensure line comments use the correct syntax for the programming language (e.g. "#" for Python, "--" for Lua).
For code blocks use four backticks to start and end.
Avoid wrapping the whole response in triple backticks.
Do not include diff formatting unless explicitly asked.
Do not include line numbers in code blocks.

When given a task:
1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in pseudocode.
2. When outputting code blocks, ensure only relevant code is included, avoiding any repeating or unrelated code.
3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.

Additional context:
The current date is %s.
The user's Neovim version is %s.
The user is working on a %s machine. Please respond with system specific commands if applicable.
]], args.language or "English", os.date("%B %d, %Y"),
               vim.version().major .. "." .. vim.version().minor .. "." ..
                   vim.version().patch, machine)
end

return {
    "olimorris/codecompanion.nvim",
    lazy = false,
    dependencies = {
        "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter",
        "folke/noice.nvim", "OXY2DEV/markview.nvim", {
            "ravitemer/mcphub.nvim",
            enabled = false,
            dependencies = {"nvim-lua/plenary.nvim"},
            build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
            config = function()
                local mcphub = require("mcphub")
                mcphub.setup({
                    workspace = {
                        look_for = {
                            ".mcphub/servers.json", ".vscode/mcp.json",
                            ".cursor/mcp.json", ".nvim/mcp.json"
                        }
                    },
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
    config = function()
        -- local default_config = vim.deepcopy(
        --                            require("codecompanion.config").config)

        local system_prompt = function(opts)
            local default_system_prompt = default_system_prompt_func(opts)
            -- local default_system_prompt = default_config.opts
            --                                   .system_prompt(opts)
            local rules = get_merged_ai_config().rules

            local llm_rule = ""
            if rules ~= nil then
                llm_rule = [[


<<IMPORANT>>
You should follow the following rules to the letter:
]]
                for _, rule in ipairs(rules) do
                    llm_rule = llm_rule .. "- " .. rule .. "\n"
                end
                llm_rule = llm_rule .. [[

DO NOT VIOLATE THESE RULES AT ANY COST.
<<IMPORANT SECTION END>>
]]
            end

            return default_system_prompt .. llm_rule
        end

        require("codecompanion").setup({
            opts = {
                log_level = "INFO",
                job_start_delay = 100,
                submit_delay = 100,
                system_prompt = system_prompt
            },
            extensions = {
                -- mcphub = {
                --     callback = "mcphub.extensions.codecompanion",
                --     opts = {
                --         make_vars = true,
                --         make_slash_commands = true,
                --         show_result_in_chat = true
                --     }
                -- }
            },
            strategies = {
                chat = {
                    adapter = "claude_haiku",
                    tools = {
                        groups = {
                            ["dev"] = {
                                description = "Full Stack Developer - Can run code, edit code and modify files",
                                prompt = [[ I'm giving you access to the ${tools} to help you perform coding tasks. 

Memory tools are super important, and you have to be organized with it. Use the following structure to organize your though:
  - README.md # contains the summary of the project, current active task, etc
  - knowledge_base/ # contains all knowledge tree about the project
    - topic.md
    - topic/
      - subtopic.md
  - task/ # contains all task summaries that you have to do
    - 0001-task-name.md
    - 0002-task-name.md
    - ...
  - plan/ # contains the detailed plan for each task
    - 0001-plan-name.md
    - 0002-plan-name.md
    - ...

<<IMPORANT>>
Consult the knowledge base if you have any questions. If the knowledge base doesn't have the answer, or it's outdated, update it.
<<IMPORANT SECTION END>>
]],
                                tools = {
                                    "cmd_runner", "create_file", "delete_file",
                                    "file_search", "get_changed_files",
                                    "grep_search", "insert_edit_into_file",
                                    "list_code_usages", "read_file", "memory"
                                },
                                opts = {collapse_tools = true}
                            }
                        },

                        ["memory"] = {opts = {requires_approval = false}},
                        opts = {
                            default_tools = {
                                -- "full_stack_dev"
                                -- "use_mcp_tool", "access_mcp_resource", "mcp"
                            }
                        }
                    }
                },
                inline = {
                    adapter = "claude_haiku",
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
                cmd = {adapter = "claude_haiku"}
            },
            adapters = {
                opts = {show_defaults = false},
                grok = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        name = "grok",
                        formatted_name = "Grok",
                        url = "https://api.x.ai/v1/chat/completions",
                        env = {api_key = get_api_key_cmd("grok")},
                        opts = {stream = true, tools = true, vision = true},
                        schema = {model = {default = "grok-4-fast-reasoning"}}
                    })
                end,
                claude_sonnet = function()
                    return require("codecompanion.adapters").extend("anthropic",
                                                                    {
                        name = "claude_sonnet",
                        formatted_name = "Claude Sonnet",
                        env = {api_key = get_api_key_cmd("anthropic")},
                        schema = {
                            model = {default = "claude-sonnet-4-5-20250929"},
                            extended_thinking = {default = true}
                        }
                    })
                end,
                claude_haiku = function()
                    return require("codecompanion.adapters").extend("anthropic",
                                                                    {
                        name = "claude_haiku",
                        formatted_name = "Claude Haiku",
                        env = {api_key = get_api_key_cmd("anthropic")},
                        schema = {
                            model = {default = "claude-haiku-4-5-20251001"},
                            extended_thinking = {default = true}
                        }
                    })
                end,
                claude_opus = function()
                    return require("codecompanion.adapters").extend("anthropic",
                                                                    {
                        name = "claude_opus",
                        formatted_name = "Claude Opus",
                        env = {api_key = get_api_key_cmd("anthropic")},
                        schema = {
                            model = {default = "claude-opus-4-5-20251101"},
                            extended_thinking = {default = true}
                        }
                    })
                end,
                gemini_pro = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        name = "gemini_pro",
                        formatted_name = "Gemini Pro",
                        env = {api_key = get_api_key_cmd("gemini")},
                        schema = {model = {default = "gemini-2.5-pro"}}
                    })
                end,
                gemini_flash = function()
                    return require("codecompanion.adapters").extend("gemini", {
                        name = "gemini_flash",
                        formatted_name = "Gemini Flash",
                        env = {api_key = get_api_key_cmd("gemini")},
                        schema = {model = {default = "gemini-2.5-flash"}}
                    })
                end
            },
            prompt_library = {
                ["Code Review"] = {
                    adapter = "claude_haiku",
                    strategy = "chat",
                    description = "Review the current revision and provide feedback",
                    opts = {
                        index = 2,
                        short_name = "r",
                        auto_submit = true,
                        user_prompt = false
                    },
                    prompts = {
                        {
                            role = constants.USER_ROLE,
                            content = function()
                                vim.g.codecompanion_auto_tool_mode = true
                                return code_review_system_prompt
                            end
                        }
                    }
                },
                ["Commit"] = {
                    adapter = "claude_haiku",
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
                    adapter = "claude_haiku",
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

                                    local step_header =
                                        "@{dev} You are required to write code following the instructions provided below"
                                    if test_cmd ~= "" then
                                        step_header = step_header ..
                                                          " and test the correctness by running the designated test suite"
                                    end
                                    step_header = step_header .. "."

                                    local steps_content =
                                        [[### Steps to Follow

]] .. step_header .. [[ Follow these steps exactly:

1. Understand the context. #{buffer} is the active file and other required files can be accessed using mcp.
2. Plan carefully on how you will fulfill the requirements.
3. Update the code in the project.
]]

                                    local test_steps = ""
                                    if test_cmd ~= "" then
                                        test_steps = string.format(
                                                         [[4. Then use the cmd_runner tool to run the test suite with `%s` (do this after you have updated the code)]],
                                                         test_cmd)
                                    else
                                        test_steps =
                                            [[4. Then use the cmd_runner tool to run the test suite]]
                                    end
                                    test_steps = test_steps ..
                                                     "\n5. Make sure you trigger both tools in the same response"

                                    local repeat_step = ""
                                    if test_cmd ~= "" then
                                        repeat_step =
                                            "We\'ll repeat this cycle until the requirements is met. "
                                    end

                                    return
                                        steps_content .. test_steps .. "\n\n" ..
                                            repeat_step ..
                                            [[Ensure no deviations from these steps.

Hints:
- Always read the file using mcp tool before making any changes to make sure you edit the file correctly. 
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
                                    return
                                        _G.codecompanion_current_tool ==
                                            "cmd_runner"
                                end,
                                -- Repeat until the tests pass, as indicated by the testing flag
                                -- which the cmd_runner tool sets on the chat buffer
                                repeat_until = function(chat)
                                    return
                                        chat.tool_registry.flags.testing == true
                                end,
                                content = "Make sure the code works"
                            }
                        }
                    }
                },
                ["plan"] = {
                    adapter = "claude_sonnet",
                    strategy = "chat",
                    description = "Plan changes",
                    opts = {index = 1, short_name = "p"},
                    prompts = {
                        {
                            role = constants.USER_ROLE,
                            content = [[@{dev} Write a plan and todos for the following task. write them as detail as possible. Store your plan and todos in your memory.

Task:
]],
                            opts = {visible = true}
                        }
                    }
                },
                ["execute-plan"] = {
                    adapter = "claude_sonnet",
                    strategy = "chat",
                    description = "Execute plan in memory",
                    opts = {index = 1, short_name = "xp", auto_submit = true},
                    prompts = {
                        {
                            role = constants.USER_ROLE,
                            content = [[@{dev} Execute the current task]],
                            opts = {visible = true}
                        }
                    }
                }
            },
            display = {
                action_palette = {opts = {show_default_prompt_library = false}},
                chat = {show_tool_processing = true},
                diff = {enabled = true}
            }
        })
    end,

    keys = {
        {
            "<leader>rr",
            "<cmd>CodeCompanionChat toggle<cr>",
            desc = "Toggle chat"
        },
        {
            "<leader>fr",
            "<cmd>CodeCompanionAction<cr>",
            desc = "Code Companion Actions"
        }, {"<leader>rC", "<cmd>CodeCompanion /c<cr>", desc = "Commit"},
        {
            "<leader>rc",
            "<cmd>CodeCompanion /cm<cr>",
            desc = "Suggest commit message"
        }, {
            "<leader>rd",
            "<cmd>CodeCompanionChat claude_sonnet<cr>",
            desc = "New Chat (Claude Sonnet)"
        }, {
            "<leader>rf",
            "<cmd>CodeCompanionChat claude_haiku<cr>",
            desc = "New Chat (Claude Haiku)"
        }, {
            "<leader>ra",
            function() start_agent_prompt("claude_haiku") end,
            desc = "Claude Haiku Agent"
        }, {
            "<leader>rA",
            function() start_agent_prompt("claude_sonnet") end,
            desc = "Claude Sonnet Agent"
        }, {
            "<leader>ro",
            function() start_agent_prompt("claude_opus") end,
            desc = "Claude Opus Agent"
        },
        {
            "<leader>rp",
            "<cmd>CodeCompanion /p<cr>",
            desc = "Claude Sonnet Planner"
        },
        {
            "<leader>rx",
            "<cmd>CodeCompanion /xp<cr>",
            desc = "Claude Sonnet Planner"
        }
    }
}

