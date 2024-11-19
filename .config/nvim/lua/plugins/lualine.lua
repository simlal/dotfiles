return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			theme = "catppucin",
			sections = {
				lualine_b = {
					{
						"branch",
						fmt = function(branch)
							local win_width = vim.api.nvim_win_get_width(0)
							local max_length = math.floor(win_width / 5) -- Adjust the divisor as needed
							if #branch > max_length then
								return branch:sub(1, max_length - 3) .. "..."
							end
							return branch
						end,
					},
				},
			},
		},
	},
}
