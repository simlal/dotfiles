return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				background = { dark = "mocha" },
				-- other optional configurations
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	-- other colorschemes if any
	{
		"ellisonleao/gruvbox.nvim",
		priority = 999,
		init = function()
			vim.o.background = "dark"
			-- Remove or comment out the gruvbox colorscheme load.
			-- vim.cmd.colorscheme("gruvbox")
		end,
	},
}
