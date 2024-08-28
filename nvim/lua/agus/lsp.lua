vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("LspMappings", {}),
	callback = function(ev)
		-- enable inlay hints

		-- this code enable neovim naive inlay hints, however the display is not configurable, so we use
		-- felpafel/inlay-hint.nvim instead
		-- if vim.lsp.inlay_hint then
		-- 	vim.lsp.inlay_hint.enable(true, { ev.buf })
		-- end
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		---@diagnostic disable-next-line: need-check-nil
		if client.supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
			vim.keymap.set("n", "<leader>i", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
			end, { buffer = ev.buf })
		end

		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
		vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { buffer = ev.buf, desc = "Go to definition" })
		vim.keymap.set(
			"n",
			"gi",
			"<cmd>Telescope lsp_implementations<CR>",
			{ buffer = ev.buf, desc = "Go to implementation" }
		)
		vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { buffer = ev.buf, desc = "Go to references" })

		-- don't map if the key is already set
		if vim.fn.maparg("<leader>ii", "n") == "" then
			vim.keymap.set(
				"n",
				"<leader>ii",
				require("actions-preview").code_actions,
				{ buffer = ev.buf, desc = "Code action" }
			)
		end

		if vim.fn.maparg("<leader>ii", "v") == "" then
			vim.keymap.set(
				"v",
				"<leader>ii",
				require("actions-preview").code_actions,
				{ buffer = ev.buf, desc = "Code action" }
			)
		end

		if vim.fn.maparg("<leader>ir", "n") == "" then
			vim.keymap.set("n", "<leader>ir", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true, desc = "Rename" })
		end

		if vim.fn.maparg("<leader>if", "n") == "" then
			vim.keymap.set("n", "<leader>if", require("conform").format, { buffer = ev.buf, desc = "Format code" })
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
	end,
})
