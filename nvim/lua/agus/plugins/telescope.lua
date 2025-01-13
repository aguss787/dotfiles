return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                file_ignore_patterns = {".git/", "target/"},
                pickers = {find_files = {hidden = true, no_ignore = true}},
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                    }
                }
            }
        })

        telescope.load_extension("fzf")
    end,
    keys = {
        {
            "<leader>ff",
            function()
                require("telescope.builtin").find_files({hidden = true})
            end,
            desc = "Find Files"
        }, {
            "<leader>fg",
            function() require("telescope.builtin").live_grep() end,
            desc = "Grep"
        }, {
            "<leader>fb",
            function() require("telescope.builtin").buffers() end,
            desc = "Buffers"
        }, {
            "<leader>fh",
            function() require("telescope.builtin").help_tags() end,
            desc = "Help Tags"
        }, {
            "<leader>fd",
            function() require("telescope.builtin").diagnostics() end,
            desc = "Diagnostics"
        }, {
            "<leader>fs",
            function() require("telescope.builtin").git_status() end,
            desc = "Git Status"
        }
    }
}
