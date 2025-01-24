return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			-- Helper function to truncate strings
			local function truncate_string(str, dynamic_max)
				local fixed_max = 25
				if #str > dynamic_max then
					return str:sub(1, dynamic_max - 3) .. "..." -- Truncate to dynamic_max
				elseif #str > fixed_max then
					return str:sub(1, fixed_max - 3) .. "..." -- Truncate to fixed_max
				end
				return str -- No truncation needed
			end

			-- Define condition for window width
			local function is_wide_enough()
				return vim.api.nvim_win_get_width(0) > 100
			end

			-- Get the trouble symbols
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
			})

			return {
				theme = "catppucin",
				sections = {
					lualine_b = {
						{
							function()
								local dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
								local win_width = vim.api.nvim_win_get_width(0)
								local dynamic_max = math.floor(win_width / 6)
								return truncate_string(dirname, dynamic_max)
							end,
							icon = "",
						},
						{
							"branch",
							fmt = function(branch)
								local win_width = vim.api.nvim_win_get_width(0)
								local dynamic_max = math.floor(win_width / 6)
								return truncate_string(branch, dynamic_max)
							end,
						},
						"diff",
						"diagnostics",
					},
					lualine_c = {
						{ "filename", path = 0 },
						-- Use symbols with the condition
						{
							symbols.get,
							cond = function()
								return symbols.has() and is_wide_enough()
							end,
						},
					},
				},
			}
		end,
	},
}
