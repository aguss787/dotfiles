return {
    'RishabhRD/nvim-lsputils',
    dependencies = {'RishabhRD/popfix'},
    config = function()
        vim.g.lsp_utils_location_opts = {mode = 'editor'}

        vim.g.lsp_utils_codeaction_opts = {mode = 'editor'}

        vim.lsp.handlers['textDocument/codeAction'] = require(
                                                          'lsputil.codeAction').code_action_handler
        vim.lsp.handlers['textDocument/references'] = require(
                                                          'lsputil.locations').references_handler
        vim.lsp.handlers['textDocument/definition'] = require(
                                                          'lsputil.locations').definition_handler
        vim.lsp.handlers['textDocument/declaration'] = require(
                                                           'lsputil.locations').declaration_handler
        vim.lsp.handlers['textDocument/typeDefinition'] = require(
                                                              'lsputil.locations').typeDefinition_handler
        vim.lsp.handlers['textDocument/implementation'] = require(
                                                              'lsputil.locations').implementation_handler
        vim.lsp.handlers['textDocument/documentSymbol'] = require(
                                                              'lsputil.symbols').document_handler
        vim.lsp.handlers['workspace/symbol'] =
            require('lsputil.symbols').workspace_handler
    end
}
