return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        suggestion = {
            auto_trigger = true,
            keymap = {
                accept_line = "<M-j>",
                accept_word = "<M-l>",
                accept = "<M-k>"
            }
        }
    }
}

