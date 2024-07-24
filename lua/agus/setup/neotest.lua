require('neotest').setup({
	adapters = {
		require('rustaceanvim.neotest')
	},
	icons = {
		passed = "✅",
		running = "🏃",
		failed = "❌",
		notify = "🔔",
		unknown = "?",
		skipped = "⏭️",
		watching = "🔭"
	},
	summary = {
		mappings = {
			target = "T"
		}
	}
})

