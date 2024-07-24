local telescope = require('telescope')
telescope.setup {
	defaults = {
		file_ignore_patterns = {
			".git/",
			"target/",
		},
		pickers = {
			find_files = {
				hidden = true,
				no_ignore = true,
			}
		}
	}
}

