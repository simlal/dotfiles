return {
	{
		"nvimdev/dashboard-nvim",
		event = "VimEnter",
		config = function()
			require("dashboard").setup({
				theme = "doom",
				hide = { tabline = true },
				config = {
					vertical_center = true,
					header = {
						"",
						"",
						"",
						"███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
						"████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
						"██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
						"██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
						"██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
						"╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
						"",
						"",
						"",
					},
					center = {
						{
							action = "Telescope find_files",
							desc = " Find file",
							icon = " ",
							key = "<leader>sf",
						},
						{
							action = "Telescope oldfiles",
							desc = " Recent files",
							icon = " ",
							key = "<leader>s.",
						},
						{
							action = "Telescope find_files cwd=~/dotfiles/.config/nvim",
							desc = " Config files",
							icon = " ",
							key = "<leader>sn",
						},
						{ action = "qa", desc = " Quit", icon = " ", key = "q" },
					},
					footer = function()
						local stats = require("lazy").stats()
						local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
						-- stylua: ignore
						return { "⚡ Neovim loaded "..stats.loaded.."/"..stats.count.." plugins in "..ms.."ms" }
					end,
				},
			})
			for _, button in ipairs(require("dashboard").opts.config.center) do
				button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
				button.key_format = "  %s"
			end
		end,
		dependencies = { { "nvim-tree/nvim-web-devicons" } },
	},
}
