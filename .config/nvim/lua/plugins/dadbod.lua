return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = vim.g.have_nerd_font
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "dbout" },
			callback = function()
				vim.opt.foldenable = false
			end,
		})
		vim.keymap.set("n", "<leader>td", "<cmd>DBUIToggle<CR>", { desc = "[D]adbod UI" })
	end,
}
