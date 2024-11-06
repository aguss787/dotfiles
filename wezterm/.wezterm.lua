-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.window_background_opacity = 1

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 10

config.enable_tab_bar = false
config.window_close_confirmation = "NeverPrompt"

-- config.default_prog = { "/sbin/tmux", "new", "-A", "-s", "terminal" }
config.color_scheme = "Catppuccin Mocha"

-- and finally, return the configuration to wezterm
return config
