local wz_action = require("wezterm").action

local M = {}

M.multiple_actions = function(keys)
	local actions = {}
	for key in keys:gmatch(".") do
		table.insert(actions, wz_action.SendKey({ key = key }))
	end

	table.insert(actions, wz_action.SendKey({ key = "\n" }))
	return wz_action.Multiple(actions)
end

M.key_table = function(mods, key, action)
	return {
		mods = mods,
		key = key,
		action = action,
	}
end

M.cmd_key = function(key, action)
	return M.key_table("CMD", key, action)
end

M.cmd_to_tmux_prefix = function(key, tmux_key)
	return M.cmd_key(
		key,
		wz_action.Multiple({
			wz_action.SendKey({ mods = "CTRL", key = "b" }),
			wz_action.SendKey({ key = tmux_key }),
		})
	)
end

return M
