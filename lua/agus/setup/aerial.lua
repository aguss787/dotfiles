require("aerial").setup({
  backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },

	-- disable nort font
	nerd_font = false,

	attach_mode = "global",
	layout = {
		default_direction = "left",
		placement = "edge",
	},

	lsp = {
		diagnostics_trigger_update = true,
	},

	autojump = true,
	keymaps = {
		["o"] = "actions.jump"
	}
});
