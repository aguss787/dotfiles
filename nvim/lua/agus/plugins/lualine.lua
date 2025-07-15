return {
    "nvim-lualine/lualine.nvim",
    dependencies = {"yavorski/lualine-macro-recording.nvim"},
    opts = {
        theme = "catppuccin",
        sections = {
            lualine_x = {"encoding", "fileformat", "filetype"},
            lualine_c = {"filename", "macro_recording"}
        }
    }
}
