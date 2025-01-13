return {
    "kevinhwang91/nvim-ufo",
    dependencies = {"kevinhwang91/promise-async"},
    event = {"BufEnter"},
    opts = {
        provider_selector = function(bufnr, filetype, buftype)
            return {"treesitter", "indent"}
        end
    },
    keys = {
        {
            "zp",
            function() require("ufo").peekFoldedLinesUnderCursor() end,
            desc = "Peek folded lines under cursor"
        }
    }
}
