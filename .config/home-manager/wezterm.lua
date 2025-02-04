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
config.font_size = 14

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
	bottom = 1,
}
config.window_decorations = "NONE"
config.enable_scroll_bar = false
config.window_close_confirmation = "NeverPrompt"

------------------------
------ workspace -------
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

------------------------
---- status/tab bar ----
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_and_split_indices_are_zero_based = false

-- Change Left tab bar using the docs example!
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = "#0b0022"
	local background = "#1b1032"
	local foreground = "#808080"

	if tab.is_active then
		background = "#5a3b8a"
		foreground = "#c0c0c0"
	elseif hover then
		background = "#3b3052"
		foreground = "#909090"
	end

	local edge_foreground = background

	local title = tab_title(tab)

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

wezterm.on("update-right-status", function(window, pane)
	local date = wezterm.strftime("%b-%-d %H:%M ")

	-- Battery indicator
	local bat = ""
	for _, b in ipairs(wezterm.battery_info()) do
		bat = "🔋" .. string.format("%.0f%%", b.state_of_charge * 100)
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
	elseif mode == "resize_pane" then
		mode_indicator = wezterm.format({
			{ Foreground = { Color = "#ff00ff" } },
			{ Text = "📐 Resize Pane" },
		})
	elseif mode == "workspaces" then
		mode_indicator = wezterm.format({
			{ Foreground = { Color = "#00ff00" } },
			{ Text = "🛠️ Workspaces" },
		})
	else
		-- Default mode (if no active mode)
		mode_indicator = wezterm.format({
			-- { Foreground = { Color = "#00ff00" } },
			{ Text = "⚡ Default" },
		})
	end

	local active_workspace = "🖥️ " .. window:active_workspace()

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

	-- Get current keyboard layout
	-- local function get_current_layout()
	-- 	local layout_process = wezterm.run_child_process({ "setxkbmap", "-query" })
	-- 	local layout_output = layout_process:read()
	--
	-- 	-- Extract the first layout (the active layout is always first in the list)
	-- 	local layout = layout_output:match("layout:s*(%S+)") -- Get the first layout
	-- 	return layout
	-- end
	-- local current_layout = get_current_layout()
	-- "⌨️ "
	--
	-- Set the right status with the mode, LEADER, battery, date, and keyboard layout
	local padding = "   "
	window:set_right_status(wezterm.format({
		{
			Text = mode_indicator
				.. padding
				.. ldr_key
				.. padding
				.. active_workspace
				.. padding
				.. bat
				.. padding
				.. date,
		},
	}))
end)

-- -- Set the right status with the mode, LEADER, battery, and date
-- window:set_right_status(wezterm.format({
-- 	{ Text = mode_indicator .. "   " .. ldr_key .. "   " .. bat .. "   " .. date },
-- }))
-- end)

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
		key = "e",
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
	-- key tables: resizing panes, workspace management
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	{
		key = "o",
		mods = "LEADER",
		action = wezterm.action.ActivateKeyTable({
			name = "workspaces",
			timeout_milliseconds = 1500,
		}),
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
config.key_tables = {
	resize_pane = {
		{ key = "LeftArrow", action = wezterm.action.AdjustPaneSize({ "Left", 8 }) },
		{ key = "RightArrow", action = wezterm.action.AdjustPaneSize({ "Right", 8 }) },
		{ key = "UpArrow", action = wezterm.action.AdjustPaneSize({ "Up", 4 }) },
		{ key = "DownArrow", action = wezterm.action.AdjustPaneSize({ "Down", 4 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
	workspaces = {
		{
			key = "n",
			action = wezterm.action.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:perform_action(
							wezterm.action.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
		{
			key = "s",
			action = wezterm.action_callback(function(win, pane)
				resurrect.save_state(resurrect.workspace_state.get_workspace_state())
				-- resurrect.window_state.save_window_action()
			end),
		},
		{
			key = "l",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_load(win, pane, function(id, label)
					local type = string.match(id, "^([^/]+)") -- match before '/'
					id = string.match(id, "([^/]+)$") -- match after '/'
					id = string.match(id, "(.+)%..+$") -- remove file extention
					local opts = {
						relative = true,
						restore_text = true,
						on_pane_restore = resurrect.tab_state.default_on_pane_restore,
					}
					if type == "workspace" then
						local state = resurrect.load_state(id, "workspace")
						resurrect.workspace_state.restore_workspace(state, opts)
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), id)
					elseif type == "window" then
						local state = resurrect.load_state(id, "window")
						resurrect.window_state.restore_window(pane:window(), state, opts)
					elseif type == "tab" then
						local state = resurrect.load_state(id, "tab")
						resurrect.tab_state.restore_tab(pane:tab(), state, opts)
					end
				end)
			end),
		},
		{
			key = "r",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for workspace",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
						resurrect.save_state(resurrect.workspace_state.get_workspace_state())
					end
				end),
			}),
		},
		{
			key = "d",
			action = wezterm.action_callback(function(win, pane)
				resurrect.fuzzy_load(win, pane, function(id)
					resurrect.delete_state(id)
				end, {
					title = "Delete State",
					description = "Select State to Delete and press Enter = accept, Esc = cancel, / = filter",
					fuzzy_description = "Search State to Delete: ",
					is_fuzzy = true,
				})
			end),
		},
		{ key = "Escape", action = "PopKeyTable" },
	},
}

------------------------
---------- END ---------
return config
