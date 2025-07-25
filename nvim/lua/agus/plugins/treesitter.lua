return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        ---@diagnostic disable-next-line: missing-fields
        configs.setup({
            highlight = {enable = true},
            incremental_selection = {enable = true},
            ensure_installed = {
                -- For markview
                "markdown", "markdown_inline", "html", -- Other
                "rust", "lua", "yaml", "python", "go", "bash", "elm"
            }
        })
    end
}
