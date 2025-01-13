return {
    "numToStr/Comment.nvim",
    event = {"BufEnter"},
    config = function()
        require("Comment").setup({mappings = {basic = false, extra = false}})

        local comment = require("Comment.api")
        vim.keymap.set("n", "<leader>cc", comment.toggle.linewise.current,
                       {desc = "Comment line"})
        vim.keymap.set("n", "<leader>c", comment.call("toggle.linewise", "g@"),
                       {expr = true, desc = "Comment line"})

        vim.keymap.set("n", "<leader>cbb", comment.toggle.blockwise.current)
        vim.keymap.set("n", "<leader>cb",
                       comment.call("toggle.blockwise", "g@"),
                       {expr = true, desc = "Comment block"})

        local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)

        vim.keymap.set("x", "<leader>cc", function()
            vim.api.nvim_feedkeys(esc, "nx", false)
            comment.toggle.linewise(vim.fn.visualmode())
        end, {desc = "Comment line"})
        vim.keymap.set("x", "<leader>cb", function()
            vim.api.nvim_feedkeys(esc, "nx", false)
            comment.toggle.blockwise(vim.fn.visualmode())
        end, {desc = "Comment block"})
    end
}
