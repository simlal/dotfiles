return {
	{
		"nvim-lualine/lualine.nvim",
		opts = function(_, opts)
			local icons = LazyVim.config.icons
			opts.sections.lualine_c = {
				LazyVim.lualine.root_dir(),
				{
					"diagnostics",
					symbols = LazyVim.config.icons.diagnostics,
				},
				{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
				{
					"filename",
					path = 0,
					symbols = {
						modified = " ●",
						readonly = " ",
						unnamed = "[No Name]",
					},
				},
			}
			opts.sections.lualine_x = {
				Snacks.profiler.status(),
				{
					function()
						return require("noice").api.status.mode.get()
					end,
					cond = function()
						return package.loaded["noice"] and require("noice").api.status.mode.has()
					end,
					color = function()
						return { fg = Snacks.util.color("Constant") }
					end,
				},
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
				{
					"diff",
					symbols = {
						added = icons.git.added,
						modified = icons.git.modified,
						removed = icons.git.removed,
					},
					source = function()
						local gitsigns = vim.b.gitsigns_status_dict
						if gitsigns then
							return {
								added = gitsigns.added,
								modified = gitsigns.changed,
								removed = gitsigns.removed,
							}
						end
					end,
				},
			}

			opts.sections.lualine_z = {}
		end,
	},
}
