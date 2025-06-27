return {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {"mason-org/mason.nvim"},
    opts = {
        ensure_installed = {
            "luaformatter", "prettier", "mypy", "black", "beautysh",
            "elm-format", "clang-format"
        }
    }
}
