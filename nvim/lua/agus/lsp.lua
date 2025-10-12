local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { features = "all" },
      -- Disable clippy
      checkOnSave = { command = "check" },
      inlayHints = { maxLength = 100 }
    }
  }
})

local home_dir = os.getenv("HOME") or ""

-- Default handlers for servers from mason-lspconfig.nvim's ensure_installed
vim.lsp.config("lua_ls", { capabilities = capabilities })
vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.config("bashls", { capabilities = capabilities })
vim.lsp.config("elmls", { capabilities = capabilities })
vim.lsp.config("clangd", { capabilities = capabilities })
vim.lsp.config("help_ls", { capabilities = capabilities })
vim.lsp.config("elixirls", {
  capabilities = capabilities,
  cmd = {
    home_dir ..
    "/.local/share/nvim/mason/packages/elixir-ls/language_server.sh"
  }
})

vim.lsp.config("cucumber_language_server", {
  capabilities = capabilities,
  settings = {
    cucumber = {
      glue = {
        -- Cucumber-JVM
        "src/test/**/*.java",                        -- Cucumber-Js
        "features/**/*.ts", "features/**/*.tsx", "features/**/*.js",
        "features/**/*.jsx",                         -- Behat
        "features/**/*.php",                         -- Behave
        "features/**/*.py",                          -- Pytest-BDD
        "tests/**/*.py",                             -- Cucumber Rust
        "tests/**/*.rs", "features/**/*.rs",         -- Cucumber-Ruby
        "features/**/*.rb",                          -- SpecFlow
        "*specs*/**/*.cs",                           -- Godog
        "features/**/*_test.go",                     -- Custom
        "**/test.rs"
      }
    }
  }
})

vim.lsp.config("gopls", {
  capabilities = capabilities,
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true
      }
    }
  }
})

-- Create a copy of capabilities for yamlls to modify it locally
local yamlls_capabilities = vim.deepcopy(capabilities)
yamlls_capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}
vim.lsp.config("yamlls", { capabilities = yamlls_capabilities })

-- delete default mappings
vim.keymap.del("n", "grr");
vim.keymap.del("n", "gri");
vim.keymap.del("n", "grn");
vim.keymap.del("n", "gra");

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("LspMappings", {}),
  callback = function(ev)
    -- enable inlay hints

    -- this code enable neovim naive inlay hints, however the display is not configurable, so we use
    -- felpafel/inlay-hint.nvim instead
    -- if vim.lsp.inlay_hint then
    -- 	vim.lsp.inlay_hint.enable(true, { ev.buf })
    -- end

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
      { buffer = ev.buf, desc = "Go to declaration" })
    vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>",
      { buffer = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>",
      { buffer = ev.buf, desc = "Go to implementation" })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>",
      { buffer = ev.buf, desc = "Go to references" })

    -- don't map if the key is already set
    if vim.fn.maparg("<leader>ii", "n") == "" then
      vim.keymap.set("n", "<leader>ii",
        require("actions-preview").code_actions,
        { buffer = ev.buf, desc = "Code action" })
    end

    if vim.fn.maparg("<leader>ii", "v") == "" then
      vim.keymap.set("v", "<leader>ii",
        require("actions-preview").code_actions,
        { buffer = ev.buf, desc = "Code action" })
    end

    if vim.fn.maparg("<leader>ir", "n") == "" then
      vim.keymap.set("n", "<leader>ir", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename" })
    end

    if vim.fn.maparg("<leader>if", "n") == "" then
      vim.keymap.set("n", "<leader>if", require("conform").format,
        { buffer = ev.buf, desc = "Format code" })
    end

    -- Enable these mappings if the filetupe is markdown
    if vim.bo.filetype == "markdown" then
      vim.keymap.set("n", "<leader>mp", function()
        vim.cmd("MarkdownPreview")
        print("Markdown preview started")
      end, { buffer = ev.buf, desc = "Start markdown preview" })

      vim.keymap.set("n", "<leader>ms", function()
        vim.cmd("MarkdownPreviewStop")
        print("Markdown preview stopped")
      end, { buffer = ev.buf, desc = "Stop markdown preview" })
    end
  end
})
