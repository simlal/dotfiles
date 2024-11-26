return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = function()
			local trouble = require("trouble")
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				hl_group = "lualine_c_normal",
			})

			return {
				theme = "catppucin",
				sections = {
					lualine_b = {
						{
							function()
								return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
							end,
							icon = "",
						},
						{
							"branch",
							fmt = function(branch)
								local win_width = vim.api.nvim_win_get_width(0)
								local max_length = math.floor(win_width / 5)
								if #branch > max_length then
									return branch:sub(1, max_length - 3) .. "..."
								end
								return branch
							end,
						},
						"diff",
						"diagnostics",
					},
					lualine_c = {
						{ "filename", path = 1 },
						-- {
						-- 	symbols.get,
						-- 	cond = symbols.has,
						-- },
					},
				},
			}
		end,
	},
}
