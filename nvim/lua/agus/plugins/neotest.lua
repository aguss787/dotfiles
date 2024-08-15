---@diagnostic disable: missing-fields

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- Neotest adapters
		"mrcjkb/rustaceanvim",
		"fredrikaverpil/neotest-golang",
	},
	-- We cannot use opts because we need to load the adapter
	config = function()
		require("neotest").setup({
			adapters = {
				require("rustaceanvim.neotest"),
				require("neotest-golang"),
			},
			summary = {
				mappings = {
					target = "T",
				},
			},
		})
	end,
	keys = {
		{
			"tt",
			function()
				require("neotest").run.run()
			end,
			desc = "Run test",
		},
		{
			"tl",
			function()
				require("neotest").run.run_last()
			end,
			desc = "Run last test",
		},
		{
			"ta",
			function()
				require("neotest").run.attach()
			end,
			desc = "Attach to test",
		},
		{
			"to",
			function()
				require("neotest").output.open()
			end,
			desc = "Open output",
		},
		{
			"tp",
			function()
				require("neotest").output_panel.toggle()
			end,
			desc = "Toggle output panel",
		},
		{
			"ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "Toggle summary",
		},
		{
			"tf",
			function()
				require("neotest").jump.next({ status = "failed" })
			end,
			desc = "Jump to next failed test",
		},
		{
			"tF",
			function()
				require("neotest").jump.prev({ status = "failed" })
			end,
			desc = "Jump to previous failed test",
		},
	},
}
