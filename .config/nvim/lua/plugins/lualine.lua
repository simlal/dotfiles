return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				theme = "moonfly",
				globalstatus = true,
				section_separators = "",
				component_separators = "",
				disabled_filetypes = { statusline = { "dashboard", "alpha" } },
			},

			sections = {
				-- LEFT
				lualine_a = { "mode" },
				lualine_b = {
					{ "branch", icon = "" },
					{
						"diff",
						symbols = {
							added = " ",
							modified = "~ ",
							removed = " ",
						},
					},
				},

				-- CENTER
				lualine_c = {
					-- CWD
					{
						function()
							return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
						end,
						icon = "",
						padding = { left = 1, right = 0 },
					},

					-- Separator (subtle breadcrumb)
					{
						function()
							return ""
						end,
						padding = { left = 1, right = 1 },
					},

					-- Filename
					{
						"filename",
						path = 0,
						symbols = {
							modified = " ●",
							readonly = " ",
							unnamed = "[No Name]",
						},
					},

					-- Filetype icon only (cleaner than text)
					{
						function()
							local icon = require("nvim-web-devicons").get_icon(vim.fn.expand("%:t"))
							return icon or ""
						end,
						padding = { left = 1 },
					},
				},

				-- RIGHT
				lualine_x = {
					-- Minimal LSP indicator
					-- TODO: add copilot icon
					{
						function()
							local buf = vim.api.nvim_get_current_buf()
							local clients = vim.lsp.get_clients({ bufnr = buf })
							-- Display all but copilot
							local names = {}
							for _, client in ipairs(clients) do
								if client.name ~= "copilot" then
									table.insert(names, client.name)
								end
							end

							if #clients == 0 then
								return ""
							end
							return "  " .. table.concat(names, ",")
						end,
						cond = function()
							return #vim.lsp.get_clients({ bufnr = 0 }) > 0
						end,
						padding = { right = 1 },
					},

					-- Diagnostics
					{
						"diagnostics",
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = " ",
						},
					},
				},

				lualine_y = { "progress" },
				lualine_z = { "location" },
			},

			inactive_sections = {
				lualine_c = { "filename" },
				lualine_x = { "location" },
			},
		},
	},
}
