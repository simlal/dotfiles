return {
	"folke/trouble.nvim",
	opts = {
		modes = {
			symbols = { -- Configure symbols mode
				win = {
					type = "split", -- split window
					relative = "win", -- relative to current window
					position = "right", -- right side
					size = 0.3, -- 30% of the window
				},
			},
		},
	}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Diagnosti[x] ",
		},
		{
			"<leader>xX",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnosti[X] ",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "LSP: [S]ymbols (Trouble)",
		},
		{
			"<leader>cx",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP: Definitions / references / ... (Trouble)",
		},
		{
			"<leader>xl",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "[L]ocation List ",
		},
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "[Q]uickfix List ",
		},
	},
}
