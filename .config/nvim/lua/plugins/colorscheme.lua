return {
	-- Keep as fallback
	{
		"catppuccin/nvim",
		name = "catppuccin",
		opts = {
			flavour = "macchiato",
			lsp_styles = {
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			integrations = {
				cmp = true,
				fzf = true,
				grug_far = true,
				gitsigns = true,
				indent_blankline = { enabled = true },
				lsp_trouble = true,
				native_lsp = {
					enabled = true,
					virtual_text = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				mason = true,
				mini = true,
				telescope = true,
				treesitter = true,
				treesitter_context = true,
				which_key = true,
			},
		},
		-- config = function(_, opts)
		-- 	require("catppuccin").setup(opts)
		-- 	vim.cmd.colorscheme("catppuccin")
		-- end,
	},
	{
		"bluz71/vim-moonfly-colors",
		name = "moonfly",
		lazy = false,
		priority = 1000,

		config = function()
			vim.g.moonflyUnderlineMatchParen = true
			vim.g.moonflyWinSeparator = 2
			vim.g.moonflyVirtualTextColor = true
			vim.cmd.colorscheme("moonfly")
		end,
	},
}
