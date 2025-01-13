return {
    "folke/trouble.nvim",
    opts = {
        open_no_results = true,
        modes = {
            important_diagnostics = {
                mode = "diagnostics",
                filter = function(items)
                    return vim.tbl_filter(function(item)
                        return item.severity ~= vim.diagnostic.severity.HINT
                    end, items)
                end
            }
        }
    },
    cmd = "Trouble",
    keys = {
        {
            "<leader>da",
            "<cmd>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics - All (Trouble)"
        }, {
            "<leader>dd",
            "<cmd>Trouble important_diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)"
        }, {
            "<leader>dD",
            "<cmd>Trouble important_diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)"
        }, {
            "<leader>dn",
            "<cmd>Trouble important_diagnostics next jump=true<cr>",
            desc = "Next (Trouble)"
        }, {
            "<leader>dp",
            "<cmd>Trouble important_diagnostics prev jump=true<cr>",
            desc = "Previous (Trouble)"
        }, {
            "<leader>df",
            "<cmd>Trouble important_diagnostics first jump=true<cr>",
            desc = "First (Trouble)"
        }, {
            "<leader>dl",
            "<cmd>Trouble important_diagnostics last jump=true<cr>",
            desc = "Last (Trouble)"
        }
    }
}
