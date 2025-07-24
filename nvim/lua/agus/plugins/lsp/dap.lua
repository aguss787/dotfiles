-- Create a reusable progress indicator for noice
local function create_progress_indicator(message_text)
    local Message = require("noice.message")
    local Manager = require("noice.message.manager")
    local Format = require("noice.text.format")

    local progress = {is_done = false, msg = nil, timer = nil}

    function progress:start()
        self.msg = Message("lsp", "progress")
        self.msg.opts.progress = {
            client_id = "client",
            client = "DapRust",
            id = os.time(),
            message = message_text
        }

        local function update_progress()
            if not self.is_done then
                Manager.add(Format.format(self.msg, "lsp_progress"))
                vim.defer_fn(update_progress, 200)
            end
        end

        update_progress()
    end

    function progress:stop()
        self.is_done = true
        if self.msg then Manager.remove(self.msg) end
    end

    return progress
end

-- Create a floating window for command output
local function create_floating_window(title, content_lines)
    content_lines = content_lines or {}

    -- Calculate window size
    local width = math.min(100, vim.o.columns - 10)
    local height = math.min(30, vim.o.lines - 10)

    -- Calculate position for centering
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- Create buffer
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].modifiable = true
    vim.bo[buf].bufhidden = 'wipe'

    -- Set initial content
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, content_lines)

    -- Create window
    local win_config = {
        relative = 'editor',
        width = width,
        height = height,
        row = row,
        col = col,
        style = 'minimal',
        border = 'rounded',
        title = title,
        title_pos = 'center'
    }

    local win = vim.api.nvim_open_win(buf, false, win_config)

    -- Set window options
    vim.wo[win].wrap = false
    vim.wo[win].cursorline = true

    -- Set buffer filetype for syntax highlighting
    vim.bo[buf].filetype = 'text'

    return {
        buf = buf,
        win = win,
        append_line = function(line)
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(win) and
                    vim.api.nvim_buf_is_valid(buf) then
                    vim.bo[buf].modifiable = true
                    local line_count = vim.api.nvim_buf_line_count(buf)
                    vim.api.nvim_buf_set_lines(buf, line_count, line_count,
                                               false, {line})
                    -- Auto-scroll to bottom
                    vim.api.nvim_win_set_cursor(win, {line_count + 1, 0})
                end
            end)
        end,
        close = function()
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, true)
                end
            end)
        end,
        set_lines = function(lines)
            vim.schedule(function()
                if vim.api.nvim_win_is_valid(win) and
                    vim.api.nvim_buf_is_valid(buf) then
                    vim.bo[buf].modifiable = true
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                end
            end)
        end
    }
end

-- Run a command with real-time output in a floating window
local function run_command_with_output(cmd, window_title, progress_message)
    local progress = create_progress_indicator(progress_message)
    progress:start()

    -- Create floating window to show command output
    local cmd_display = type(cmd) == "table" and table.concat(cmd, " ") or
                            tostring(cmd)
    local float_win = create_floating_window(window_title,
                                             {"Running: " .. cmd_display, ""})

    local result_lines = {}
    local completed = false
    local exit_code = nil

    local job_id = vim.fn.jobstart(cmd, {
        stdout_buffered = false,
        stderr_buffered = false,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(result_lines, line)
                        float_win.append_line("[STDOUT] " .. line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        float_win.append_line("[STDERR] " .. line)
                    end
                end
            end
        end,
        on_exit = function(_, code)
            completed = true
            exit_code = code
            progress:stop()
            float_win.append_line("")
            float_win.append_line("Command completed with exit code: " .. code)

            -- Auto-close the window after 2 seconds
            vim.defer_fn(function() float_win.close() end, 2000)
        end
    })

    if job_id <= 0 then
        progress:stop()
        float_win.close()
        return nil, "Failed to start command: " .. cmd_display
    end

    -- Wait for command to complete
    while not completed do vim.cmd("sleep 50m") end

    -- Join all result lines
    local result = table.concat(result_lines, "\n")

    if exit_code ~= 0 then
        return result, "Command failed with exit code: " .. exit_code
    end

    return result, nil
end

-- Create a reusable telescope picker
local function create_telescope_picker(opts)
    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    local items = opts.items or {}
    local prompt_title = opts.prompt_title or "Select item"
    local display_formatter = opts.display_formatter

    -- If no items, return nil
    if #items == 0 then return nil end

    -- If only one item and auto_select is enabled, return it
    if #items == 1 and opts.auto_select then
        if opts.on_auto_select then opts.on_auto_select(items[1]) end
        return items[1]
    end

    local co = coroutine.running()
    local selected_item = nil

    -- Prepare results for telescope
    local results
    if display_formatter then
        results = {}
        for _, item in ipairs(items) do
            table.insert(results, {
                value = item,
                display = display_formatter(item),
                ordinal = display_formatter(item)
            })
        end
    else
        results = items
    end

    -- Create finder configuration
    local finder_opts = {results = results}
    if display_formatter then
        finder_opts.entry_maker = function(entry)
            return {
                value = entry.value,
                display = entry.display,
                ordinal = entry.ordinal
            }
        end
    end

    pickers.new({}, {
        prompt_title = prompt_title,
        finder = finders.new_table(finder_opts),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selection then selected_item = selection.value end
                if co then coroutine.resume(co) end
            end)
            return true
        end
    }):find()

    if co then coroutine.yield() end

    return selected_item
end

return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio",
        "nvim-telescope/telescope.nvim", "folke/noice.nvim"
    },
    opts = {},
    init = function()
        local dap = require("dap")

        local codelldb_path = vim.fn.stdpath("data") ..
                                  "/mason/packages/codelldb/extension/adapter/codelldb"
        dap.adapters.lldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = codelldb_path,
                args = {"--port", "${port}"},
                detached = false
            }
        }

        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = {
                "--interpreter=dap", "--eval-command", "set print pretty on"
            }
        }

        -- Function to get the target binary path
        local function get_target_path()
            return vim.fn.getcwd() .. "/target/debug/nvim-debug"
        end

        dap.configurations.rust = {
            {
                name = "Test",
                type = "lldb",
                request = "launch",
                sourceLanguages = {"rust"},
                program = function()
                    -- Simply return the nvim-debug binary path
                    return get_target_path()
                end,
                args = function()
                    -- Function to get tests and their associated binaries from cargo nextest
                    local function get_cargo_tests_with_binaries()
                        local cmd = {
                            "cargo", "nextest", "list", "--all-features",
                            "--message-format", "json"
                        }

                        local result, error_msg =
                            run_command_with_output(cmd,
                                                    "Cargo Nextest List Output",
                                                    "Listing tests with cargo nextest")

                        if error_msg then
                            vim.notify(error_msg, vim.log.levels.ERROR)
                            return {}
                        end

                        if not result or result == "" then
                            vim.notify("No output from cargo nextest",
                                       vim.log.levels.WARN)
                            return {}
                        end

                        -- Parse JSON output
                        local ok, json_data = pcall(vim.fn.json_decode, result)
                        if not ok then
                            vim.notify(
                                "Failed to parse cargo nextest JSON output: " ..
                                    (result:sub(1, 100) or "<empty>"),
                                vim.log.levels.ERROR)
                            return {}
                        end

                        -- Extract test information with associated binaries
                        local tests_with_binaries = {}
                        if json_data["rust-suites"] then
                            for suite_key, suite_data in pairs(
                                                             json_data["rust-suites"]) do
                                local binary_info = {
                                    key = suite_key,
                                    name = suite_data["binary-name"] or
                                        suite_key,
                                    path = suite_data["binary-path"],
                                    kind = suite_data["kind"] or "unknown"
                                }

                                if suite_data["testcases"] then
                                    for test_name, test_data in pairs(
                                                                    suite_data["testcases"]) do
                                        if not test_data["ignored"] then
                                            table.insert(tests_with_binaries, {
                                                test_name = test_name,
                                                binary = binary_info
                                            })
                                        end
                                    end
                                end
                            end
                        end

                        return tests_with_binaries
                    end

                    vim.notify("Running cargo nextest command to list tests",
                               vim.log.levels.INFO)

                    -- Get available tests with their binaries
                    local tests_with_binaries = get_cargo_tests_with_binaries()

                    if #tests_with_binaries == 0 then
                        vim.notify("No tests found", vim.log.levels.WARN)
                        return {"render_test"} -- fallback
                    end

                    -- Sort tests for better UX
                    table.sort(tests_with_binaries, function(a, b)
                        return a.test_name < b.test_name
                    end)

                    -- Use telescope picker to select test
                    local selected_test_info =
                        create_telescope_picker({
                            items = tests_with_binaries,
                            prompt_title = "Select test to debug",
                            display_formatter = function(test_info)
                                return
                                    string.format("%s (%s)",
                                                  test_info.test_name,
                                                  test_info.binary.name)
                            end
                        })

                    if not selected_test_info then return {} end

                    -- Copy the associated binary to target location
                    local target_path = get_target_path()
                    local source_path = selected_test_info.binary.path

                    -- Ensure target directory exists
                    local target_dir = vim.fn.fnamemodify(target_path, ":h")
                    vim.fn.mkdir(target_dir, "p")

                    -- Copy the binary
                    local copy_cmd = string.format("cp '%s' '%s'", source_path,
                                                   target_path)
                    local copy_result = os.execute(copy_cmd)

                    if copy_result == 0 then
                        vim.notify(string.format(
                                       "Copied binary '%s' for test '%s' to debug target",
                                       selected_test_info.binary.name,
                                       selected_test_info.test_name),
                                   vim.log.levels.INFO)
                    else
                        vim.notify(string.format(
                                       "Failed to copy binary '%s' for test '%s'",
                                       selected_test_info.binary.name,
                                       selected_test_info.test_name),
                                   vim.log.levels.ERROR)
                        return {"render_test"} -- fallback
                    end

                    return {selected_test_info.test_name}
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false
            }
        }
    end,
    keys = {
        {
            "<leader>oo",
            function() require("dapui").toggle() end,
            desc = "Toggle DAP UI"
        }, {
            "<leader>ob",
            function() require("dap").toggle_breakpoint() end,
            desc = "Toggle breakpoint"
        }, {
            "<leader>or",
            function()
                require("dapui").open()
                vim.cmd("DapNew")
            end,
            desc = "Run"
        }, {
            "<leader>oR",
            function()
                require("dapui").open()
                require("dap").run_last()
            end,
            desc = "Run last"
        },
        {
            "<leader>oc",
            function() require("dap").continue() end,
            desc = "Continue"
        },
        {
            "<leader>os",
            function() require("dap").step_over() end,
            desc = "Step over"
        },
        {
            "<leader>oi",
            function() require("dap").step_into() end,
            desc = "Step into"
        },
        {
            "<leader>ou",
            function() require("dap").step_out() end,
            desc = "Step out"
        },
        {
            "<leader>ot",
            function() require("dap").terminate() end,
            desc = "Terminal"
        }
    }
}
