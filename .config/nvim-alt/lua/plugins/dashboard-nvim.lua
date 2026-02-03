return {
	"nvimdev/dashboard-nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VimEnter",
	config = function()
		local logo = [[
      ___           ___           ___                                     ___     
     /\  \         /\__\         /\  \          ___                      /\  \    
     \:\  \       /:/ _/_       /::\  \        /\  \        ___         |::\  \   
      \:\  \     /:/ /\__\     /:/\:\  \       \:\  \      /\__\        |:|:\  \  
  _____\:\  \   /:/ /:/ _/_   /:/  \:\  \       \:\  \    /:/__/      __|:|\:\  \ 
 /::::::::\__\ /:/_/:/ /\__\ /:/__/ \:\__\  ___  \:\__\  /::\  \     /::::|_\:\__\
 \:\~~\~~\/__/ \:\/:/ /:/  / \:\  \ /:/  / /\  \ |:|  |  \/\:\  \__  \:\~~\  \/__/
  \:\  \        \::/_/:/  /   \:\  /:/  /  \:\  \|:|  |   ~~\:\/\__\  \:\  \      
   \:\  \        \:\/:/  /     \:\/:/  /    \:\__|:|__|      \::/  /   \:\  \     
    \:\__\        \::/  /       \::/  /      \::::/__/       /:/  /     \:\__\    
     \/__/         \/__/         \/__/        ~~~~           \/__/       \/__/    
        ]]
		logo = string.rep("\n", 8) .. logo .. "\n\n"
		local opts = {
			theme = "doom",
			hide = {
				statusline = false,
			},
			config = {
				header = vim.split(logo, "\n"),
				center = {
					{
						action = "Telescope find_files",
						desc = " > Find File",
						icon = " ",
						key = "f",
					},
					{
						action = "Telescope oldfiles",
						desc = " > Recent Files",
						icon = " ",
						key = ".",
					},
					{
						action = "Telescope live_grep",
						desc = " > Grep",
						icon = " ",
						key = "g",
					},
					{
						action = "enew | startinsert",
						desc = " > New File",
						icon = " ",
						key = "n",
					},
					{
						action = "Yazi",
						desc = " > Explorer",
						icon = " ",
						key = "e",
					},
					{
						action = 'lua require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })',
						desc = " > Config",
						icon = " ",
						key = "c",
					},
					{
						action = 'lua require("persistence").load()',
						desc = " > Restore Session",
						icon = " ",
						key = "s",
					},
					{
						action = "Lazy",
						desc = " > Lazy",
						icon = "󰒲 ",
						key = "l",
					},
					{
						action = function()
							vim.api.nvim_input("<cmd>qa<cr>")
						end,
						desc = " > Quit",
						icon = " ",
						key = "q",
					},
				},

				footer = function()
					local stats = require("lazy").stats()
					local version = vim.version()

					-- Time of day emoji
					local hour = tonumber(os.date("%H"))
					local emoji = (hour < 12 and "🌅") or (hour < 18 and "🌞") or "🌙"

					-- Date + time
					local date_str = os.date("%d-%m-%Y")
					local time_str = os.date("%H:%M")

					-- Neovim version
					local nvim_version =
						string.format("  nvim %d.%d.%d", version.major, version.minor, version.patch)

					-- Plugin stats
					local plugin_info = string.format("⚡ %d/%d plugins", stats.loaded, stats.count)

					-- Current directory (shortened)
					local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")

					return {
						"",
						string.format("%s  %s • %s", emoji, time_str, date_str),
						"",
						string.format("%s  •  %s", nvim_version, plugin_info),
						"",
						"  " .. cwd,
						"",
					}
				end,

				vertical_center = true,
			},
		}

		-- Align descriptions
		for _, button in ipairs(opts.config.center) do
			button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
			button.key_format = "  %s"
		end

		require("dashboard").setup(opts)
	end,
}
