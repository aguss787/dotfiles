return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- Setup the harpoon plugin
		harpoon:setup()

		-- Add the default keybindings
		vim.keymap.set("n", "<leader>bb", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle Harpoon" })
		vim.keymap.set("n", "<leader>ba", function()
			harpoon:list():add()
		end, { desc = "Add file to harpoon" })

		-- Keybindings to go to next and previous files
		local opts = {
			ui_nav_wrap = true,
		}
		vim.keymap.set("n", "<leader>bn", function()
			harpoon:list():next(opts)
		end, { desc = "Go to next file" })
		vim.keymap.set("n", "<leader>bp", function()
			harpoon:list():prev(opts)
		end, { desc = "Go to next file" })

		-- Keybindings to go to first 4 files
		local bindings = { { 1, "q" }, { 2, "w" }, { 3, "e" }, { 4, "r" } }
		for _, binding in ipairs(bindings) do
			local idx, key = unpack(binding)
			vim.keymap.set("n", "<leader>b" .. key, function()
				harpoon:list():select(idx)
			end, { desc = "Go to file " .. idx })
		end
	end,
}
