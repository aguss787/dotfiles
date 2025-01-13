return {
    "voldikss/vim-floaterm",
    config = function()
        vim.api.nvim_create_autocmd("TermOpen", {
            group = vim.api.nvim_create_augroup("TermOpen", {}),
            pattern = "*",
            command = "stopinsert"
        })
    end,
    keys = {
        {"<leader>tt", "<cmd>FloatermToggle<cr>", {desc = "Toggle terminal"}},
        {"<leader>tc", "<cmd>FloatermNew<cr>", {desc = "New terminal"}},
        {"<leader>tk", "<cmd>FloatermKill<cr>", {desc = "Kill terminal"}},
        {"<leader>tn", "<cmd>FloatermNext<cr>", {desc = "Next terminal"}},
        {"<leader>tp", "<cmd>FloatermPrev<cr>", {desc = "Previous terminal"}}
    }
}
