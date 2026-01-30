return {
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			exclude = {
				filetypes = {
					"Trouble",
					"trouble",
					"dashboard",
					"help",
					"lazy",
					"mason",
				},
			},
		},
	},
}
