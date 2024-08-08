return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"rcarriga/nvim-notify",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local leetcode = require("leetcode")

		local lang = "rust"
		local storage = function(selected_lang)
			local defined_storages = {
				rust = vim.fn.stdpath("data") .. "/leetcode/solutions/rust/src/bin",
			}

			if defined_storages[selected_lang] ~= nil then
				return defined_storages[selected_lang]
			end

			return vim.fn.stdpath("data") .. "/leetcode/solutions/" .. lang
		end

		leetcode.setup({
			-- configuration goes here
			lang = lang,

			injector = {
				["rust"] = {
					before = { "#![allow(dead_code)]", "struct Solution;" },
					after = { "fn main() {}" },
				},
			},

			storage = {
				home = storage(lang),
			},

			keys = {
				toggle = { "q" },
				confirm = { "<CR>" },

				reset_testcases = "r",
				use_testcase = "U",
				focus_testcases = "<C-h>",
				focus_result = "<C-l>",
			},
		})
	end,
}
