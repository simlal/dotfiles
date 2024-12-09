return {
	"folke/trouble.nvim",
	opts = {}, -- for default options, refer to the configuration section for custom setup.
	cmd = "Trouble",
	keys = {
		{
			"<leader>dD",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Workspace [D]iagnostics",
		},
		{
			"<leader>dd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Current Buffer [d]iagnostics",
		},
		{
			"<leader>ts",
			"<cmd>Trouble symbols toggle focus=true win.position=right win.size=0.4<cr>",
			desc = "Code [S]ymbols",
		},
		{
			"<leader>tl",
			"<cmd>Trouble lsp toggle focus=false win.position=right win.size=0.4<cr>",
			desc = "[L]ist Code Def/Ref/Impl/...",
		},
		-- {
		-- 	"<leader>xl",
		-- 	"<cmd>Trouble loclist toggle<cr>",
		-- 	desc = "[L]ocation List ",
		-- },
		-- {
		-- 	"<leader>xq",
		-- 	"<cmd>Trouble qflist toggle<cr>",
		-- 	desc = "[Q]uickfix List ",
		-- },
	},
}
