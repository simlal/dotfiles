return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	keys = {
		{
			"<leader>ew",
			"<cmd>Trouble diagnostics toggle win.size=0.4<cr>",
			desc = "[W]orkspace Diagnostics",
		},
		{
			"<leader>e/",
			"<cmd>Trouble diagnostics toggle filter.buf=0 win.size=0.4<cr>",
			desc = "[/] Current Buffer Diagnostics",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=true win.position=right win.size=0.4<cr>",
			desc = "[S]ymbols List Current Buffer",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right win.size=0.4<cr>",
			desc = "[L]ist Code Selection Def/Ref/Impl/Type",
		},
		{
			"<leader>eq",
			"<cmd>Trouble qflist toggle win.size=0.4<cr>",
			desc = "[Q]uickfix List (Trouble)",
		},
	},
}
