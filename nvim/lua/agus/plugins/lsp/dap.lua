return {
    "rcarriga/nvim-dap-ui",
    dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    opts = {},
    keys = {
        {
            "<leader>oo",
            function() require("dapui").toggle() end,
            desc = "Toggle DAP UI"
        }, {
            "<leader>ob",
            function() require("dap").toggle_breakpoint() end,
            desc = "Toggle breakpoint"
        }, {"<leader>or", "<cmd>DapNew<cr>", desc = "Run"},
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
            desc = "Disconnect"
        }
    }
}
