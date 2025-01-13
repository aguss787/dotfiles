return {
    "tribela/vim-transparent",
    enabled = function() return os.getenv("TERMINAL_TRANSPARENT") == "TRUE" end,
    priority = 1000,
    config = function()
        vim.g.transparent_groups_add = {
            "NormalFloat", "NvimTreeNormal", "StatusLine", "StatusLineNC"
        }
    end
}
