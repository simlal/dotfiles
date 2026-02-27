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
				-- git status
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

				-- Copilot
				LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
					local clients = package.loaded["copilot"] and vim.lsp.get_clients({ name = "copilot", bufnr = 0 })
						or {}
					if #clients > 0 then
						local status = require("copilot.status").data.status
						return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
					end
				end),

				-- Other LSPs
				{
					function()
						local buf = vim.api.nvim_get_current_buf()
						local clients = vim.lsp.get_clients({ bufnr = buf })
						-- Display all but copilot
						local names = {}
						for _, client in ipairs(clients) do
							if client.name ~= "copilot" and client.name ~= "null-ls" then
								table.insert(names, client.name)
							end
						end

						if #names == 0 then
							return ""
						end
						return "󰣖 " .. table.concat(names, ",")
					end,
					cond = function()
						return #vim.lsp.get_clients({ bufnr = 0 }) > 0
					end,
					padding = { left = 1, right = 1 },
				},

				-- recording/cmdline status etc. from noice
				{
					function()
						return require("noice").api.status.command.get()
					end,
					cond = function()
						return package.loaded["noice"] and require("noice").api.status.command.has()
					end,
					color = function()
						return { fg = Snacks.util.color("Statement") }
					end,
				},
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

				-- DEBUGGER
        -- stylua: ignore
				{
					function()
						return "  " .. require("dap").status()
					end,
					cond = function()
						return package.loaded["dap"] and require("dap").status() ~= ""
					end,
					color = function()
						return { fg = Snacks.util.color("Debug") }
					end,
				},
			}

			opts.sections.lualine_z = {}
		end,
	},
}
