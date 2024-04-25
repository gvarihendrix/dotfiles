local wezterm = require('wezterm')
local _ = require('status_bar')

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { '/opt/homebrew/bin/fish', '-l' }

config.color_scheme = 'rose-pine'
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
config.font_size = 12.0

return config
