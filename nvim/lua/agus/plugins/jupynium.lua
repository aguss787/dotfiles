return {
    "kiyoon/jupynium.nvim",
    build = "python3 -m pip install --break-system-packages ."
    -- build = "conda run --no-capture-output -n jupynium pip install .",
    -- enabled = vim.fn.isdirectory(vim.fn.expand "~/miniconda3/envs/jupynium"),
}
