return {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "AndreM222/copilot-lualine", "yavorski/lualine-macro-recording.nvim"
    },
    opts = {
        theme = "catppuccin",
        sections = {
            lualine_x = {"copilot", "encoding", "fileformat", "filetype"},
            lualine_c = {"filename", "macro_recording"}
        }
    }
}
