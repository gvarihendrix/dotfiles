local wezterm = require("wezterm")
local act = wezterm.action
local os = require("os")
local _ = require("status_bar")
local k = require("utils/keys")

local move_around = function(window, pane, direction_wez, direction_nvim)
	local result = os.execute(
		"env NVIM_LISTEN_ADDRESS=/tmp/nvim"
			.. pane:pane_id()
			.. " "
			.. wezterm.home_dir
			.. "/.config/bin/wezterm.nvim.navigator"
			.. " "
			.. direction_nvim
	)
	if result then
		window:perform_action(act({ SendString = "\x17" .. direction_nvim }), pane)
	else
		window:perform_action(act({ ActivatePaneDirection = direction_wez }), pane)
	end
end

wezterm.on("move-left", function(window, pane)
	move_around(window, pane, "Left", "h")
end)

wezterm.on("move-right", function(window, pane)
	move_around(window, pane, "Right", "l")
end)

wezterm.on("move-up", function(window, pane)
	move_around(window, pane, "Up", "k")
end)

wezterm.on("move-down", function(window, pane)
	move_around(window, pane, "Down", "j")
end)

local vim_resize = function(window, pane, direction_wez, direction_nvim)
	local result = os.execute(
		"env NVIM_LISTEN_ADDRESS=/tmp/nvim"
			.. pane:pane_id()
			.. " "
			.. wezterm.home_dir
			.. "/.config/bin/wezterm.nvim.navigator"
			.. " "
			.. direction_nvim
	)
	if result then
		window:perform_action(act({ SendString = "\x1b" .. direction_nvim }), pane)
	else
		window:perform_action(act({ ActivatePaneDirection = direction_wez }), pane)
	end
end

wezterm.on("resize-left", function(window, pane)
	vim_resize(window, pane, "Left", "h")
end)

wezterm.on("resize-right", function(window, pane)
	vim_resize(window, pane, "Right", "l")
end)

wezterm.on("resize-up", function(window, pane)
	vim_resize(window, pane, "Up", "k")
end)

wezterm.on("resize-down", function(window, pane)
	vim_resize(window, pane, "Down", "j")
end)

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono", { weight = "Bold" })
config.font_size = 14.0
config.inactive_pane_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 1.0,
}
config.launch_menu = {}
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_max_width = 32
config.colors = {
	tab_bar = {
		active_tab = {
			fg_color = "#f2cdcd",
			bg_color = "#45475a",
		},
	},
}
config.switch_to_last_active_tab_when_closing_tab = true

config.pane_focus_follows_mouse = true
config.scrollback_lines = 5000

-- config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
	{ key = "[", mods = "LEADER", action = wezterm.action.ActivateCopyMode },
	{
		key = "\\",
		mods = "LEADER",
		action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
	},
	{ key = "-", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{
		-- |
		key = "{",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	{
		key = ";",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Prev"),
	},
	{
		key = "o",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Next"),
	},
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },

	{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
	{ key = "v", mods = "SHIFT|CTRL", action = wezterm.action.PasteFrom("Clipboard") },
	{ key = "c", mods = "SHIFT|CTRL", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "+", mods = "SHIFT|CTRL", action = "IncreaseFontSize" },
	{ key = "-", mods = "SHIFT|CTRL", action = "DecreaseFontSize" },
	{ key = "0", mods = "SHIFT|CTRL", action = "ResetFontSize" },
	{
		key = ",",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	{ key = "w", mods = "LEADER", action = wezterm.action.ShowTabNavigator },

	-- CTRL + (h,j,k,l) to move between panes
	{
		key = "h",
		mods = "CTRL",
		action = act({ EmitEvent = "move-left" }),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act({ EmitEvent = "move-down" }),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act({ EmitEvent = "move-up" }),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act({ EmitEvent = "move-right" }),
	},
	-- ALT + (h,j,k,l) to resize panes
	{
		key = "h",
		mods = "ALT",
		action = act({ EmitEvent = "resize-left" }),
	},
	{
		key = "j",
		mods = "ALT",
		action = act({ EmitEvent = "resize-down" }),
	},
	{
		key = "k",
		mods = "ALT",
		action = act({ EmitEvent = "resize-up" }),
	},
	{
		key = "l",
		mods = "ALT",
		action = act({ EmitEvent = "resize-right" }),
	},

	k.cmd_key(".", k.multiple_actions(":ZenMode")),
	-- k.cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
	-- k.cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
	k.cmd_key("f", k.multiple_actions(":Grep")),
	-- k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
	k.cmd_key("i", k.multiple_actions(":SmartGoTo")),
	-- k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
	-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
	-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
	-- k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
	k.cmd_key("O", k.multiple_actions(":GoToSymbol")),
	k.cmd_key("P", k.multiple_actions(":GoToCommand")),
	k.cmd_key("p", k.multiple_actions(":GoToFile")),
	k.cmd_key("q", k.multiple_actions(":qa!")),
	-- k.cmd_to_tmux_prefix("1", "1"),
	-- k.cmd_to_tmux_prefix("2", "2"),
	-- k.cmd_to_tmux_prefix("3", "3"),
	-- k.cmd_to_tmux_prefix("4", "4"),
	-- k.cmd_to_tmux_prefix("5", "5"),
	-- k.cmd_to_tmux_prefix("6", "6"),
	-- k.cmd_to_tmux_prefix("7", "7"),
	-- k.cmd_to_tmux_prefix("8", "8"),
	-- k.cmd_to_tmux_prefix("9", "9"),
	-- k.cmd_to_tmux_prefix("`", "n"),
	-- k.cmd_to_tmux_prefix("b", "b"),
	-- k.cmd_to_tmux_prefix("C", "C"),
	-- k.cmd_to_tmux_prefix("d", "D"),
	-- k.cmd_to_tmux_prefix("G", "G"),
	-- k.cmd_to_tmux_prefix("g", "g"),
	-- k.cmd_to_tmux_prefix("j", "J"),
	-- k.cmd_to_tmux_prefix("K", "T"),
	-- k.cmd_to_tmux_prefix("k", "K"),
	-- k.cmd_to_tmux_prefix("l", "L"),
	-- k.cmd_to_tmux_prefix("n", '"'),
	-- k.cmd_to_tmux_prefix("N", "%"),
	-- k.cmd_to_tmux_prefix("o", "u"),
	-- k.cmd_to_tmux_prefix("T", "!"),
	-- k.cmd_to_tmux_prefix("Y", "Y"),
	-- k.cmd_to_tmux_prefix("t", "c"),
	-- k.cmd_to_tmux_prefix("w", "x"),
	-- k.cmd_to_tmux_prefix("z", "z"),
	-- k.cmd_to_tmux_prefix("Z", "Z"),

	-- k.cmd_key(
	-- 	"R",
	-- 	act.Multiple({
	-- 		act.SendKey({ key = "\x1b" }), -- escape
	-- 		k.multiple_actions(":source %"),
	-- 	})
	-- ),

	-- k.cmd_key(
	-- 	"s",
	-- 	act.Multiple({
	-- 		act.SendKey({ key = "\x1b" }), -- escape
	-- 		k.multiple_actions(":w"),
	-- 	})
	-- ),

	-- {
	-- 	mods = "CMD|SHIFT",
	-- 	key = "}",
	-- 	action = act.Multiple({
	-- 		act.SendKey({ mods = "CTRL", key = "b" }),
	-- 		act.SendKey({ key = "n" }),
	-- 	}),
	-- },
	-- {
	-- 	mods = "CMD|SHIFT",
	-- 	key = "{",
	-- 	action = act.Multiple({
	-- 		act.SendKey({ mods = "CTRL", key = "b" }),
	-- 		act.SendKey({ key = "p" }),
	-- 	}),
	-- },

	-- {
	-- 	mods = "CTRL",
	-- 	key = "Tab",
	-- 	action = act.Multiple({
	-- 		act.SendKey({ mods = "CTRL", key = "b" }),
	-- 		act.SendKey({ key = "n" }),
	-- 	}),
	-- },

	-- {
	-- 	mods = "CTRL|SHIFT",
	-- 	key = "Tab",
	-- 	action = act.Multiple({
	-- 		act.SendKey({ mods = "CTRL", key = "b" }),
	-- 		act.SendKey({ key = "n" }),
	-- 	}),
	-- },

	-- {
	-- 	mods = "CMD",
	-- 	key = "~",
	-- 	action = act.Multiple({
	-- 		act.SendKey({ mods = "CTRL", key = "b" }),
	-- 		act.SendKey({ key = "p" }),
	-- 	}),
	-- },
}
-- 	set_environment_variables = {},

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- config.front_end = "Software" -- OpenGL doesn't work quite well with RDP.
	-- config.term = "" -- Set to empty so FZF works on windows
	table.insert(config.launch_menu, { label = "PowerShell", args = { "powershell.exe", "-NoLogo" } })

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(config.launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end
else
	table.insert(config.launch_menu, { label = "bash", args = { "bash", "-l" } })
	table.insert(config.launch_menu, { label = "fish", args = { "fish", "-l" } })
end

return config
