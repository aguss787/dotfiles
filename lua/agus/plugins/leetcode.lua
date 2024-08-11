return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
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

			hooks = {
				["question_enter"] = {
					function(question)
						local file = question.file
						local file_path = question.file:absolute()
						local parent = file:parent()
						local parent_path = parent:absolute()

						local file_name = string.sub(file_path, parent_path:len() + 2)
						local new_file_name = file_name:gsub("^(%d+).", "%1_")

						local new_file_path = parent:joinpath(new_file_name)

						if not new_file_path:exists() then
							file:rename({
								new_name = new_file_path:absolute(),
							})
						end

						file:rm()
						os.execute("ln -s " .. new_file_path .. " " .. file_path)
					end,
				},
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
