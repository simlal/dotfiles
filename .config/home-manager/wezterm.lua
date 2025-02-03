local wezterm = require("wezterm")
local config = wezterm.config_builder()

------------------------
------- constants ------
local home = os.getenv("HOME")

------------------------
---- default shell -----
config.default_prog = { home .. "/.nix-profile/bin/zsh", "-l" }
config.default_cwd = home

------------------------
---- theme and fonts ---
config.color_scheme = "Catppuccin Frappe"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 15

------------------------
------- cursor ---------
config.cursor_blink_rate = 750
config.cursor_thickness = 2
config.default_cursor_style = "BlinkingUnderline"

------------------------
------- window ---------
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.window_decorations = "NONE"
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"

------------------------
---- status/tab bar ----
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = false

wezterm.on("update-right-status", function(window, pane)
	local date = wezterm.strftime("%b %-d %H:%M ")

	-- Battery indicator
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
	end

	-- LEADER key indicator
	local ldr_key = wezterm.format({
		{ Foreground = { Color = "#d3d3d3" } },
		{ Text = "󰒲  LEADER" },
	})

	-- If LEADER key is active, change the color and make it bold
	if window:leader_is_active() then
		ldr_key = wezterm.format({
			{ Attribute = { Intensity = "Bold" } },
			{ Foreground = { Color = "#ff4500" } },
			{ Text = "🔥 LEADER" },
		})
	end

	-- Mode indicator
	local mode = window:active_key_table() or "default"
	local mode_indicator = ""

	-- Display different mode indicators based on the active mode
	if mode == "copy_mode" then
		mode_indicator = wezterm.format({
			{ Foreground = { Color = "#ffcc00" } },
			{ Text = "✂️ Copy Mode" },
		})
	elseif mode == "search_mode" then
		mode_indicator = wezterm.format({
			{ Foreground = { Color = "#00ffff" } },
			{ Text = "🔍 Search Mode" },
		})
	else
		-- Default mode (if no active mode)
		mode_indicator = wezterm.format({
			-- { Foreground = { Color = "#00ff00" } },
			{ Text = "⚡ Default" },
		})
	end

	-- Set the right status with the mode, LEADER, battery, and date
	window:set_right_status(wezterm.format({
		{ Text = mode_indicator .. "   " .. ldr_key .. "   " .. bat .. "   " .. date },
	}))
end)

------------------------
-------- KEYMAPS -------
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1500 }
--
-- key table (resizing, etc.)
config.keys = {
	-- tab navigation / management
	{
		mods = "LEADER",
		key = "t",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "LEADER",
		key = "w",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		mods = "LEADER",
		key = "x",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	{
		mods = "LEADER",
		key = "[",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "]",
		action = wezterm.action.ActivateTabRelative(1),
	},
	-- rename tab
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything
				-- An empty string if they just hit enter
				-- Or the actual line of text they wrote
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- pane splitting
	{
		mods = "LEADER|SHIFT",
		key = "|",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "LEADER",
		key = "-",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- pane navigation
	{
		mods = "LEADER",
		key = "h",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "LEADER",
		key = "j",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "LEADER",
		key = "k",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "LEADER",
		key = "l",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	-- pane sizing
	{
		mods = "LEADER",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 10 }),
	},
	{
		mods = "LEADER",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 10 }),
	},
	{
		mods = "LEADER",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 10 }),
	},
	{
		mods = "LEADER",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 10 }),
	},

	-- command palette override
	{
		key = "p",
		mods = "LEADER",
		action = wezterm.action.ShowLauncher,
	},
	-- search mode
	{
		key = "/",
		mods = "LEADER",
		action = wezterm.action.Search({ CaseInSensitiveString = "" }),
	},
	{
		key = "*",
		mods = "LEADER|SHIFT",
		action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
	},
	-- Copy modes
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
}

-- tab navigation
for i = 0, 9 do
	-- leader + number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = wezterm.action.ActivateTab(i - 1),
	})
end

-- key tables
-- config.key_tables = {
-- 	resize_pane = {
-- 		{ key = "LeftArrow", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
-- 		{ key = "RightArrow", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
-- 		{ key = "UpArrow", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
-- 		{ key = "DownArrow", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
--
-- 		-- Cancel the mode by pressing escape
-- 		{ key = "Escape", action = "PopKeyTable" },
-- 	},
-- }

------------------------
---------- END ---------
return config
