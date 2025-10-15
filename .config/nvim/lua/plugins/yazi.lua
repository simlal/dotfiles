---@type LazySpec
return {
	"mikavilpas/yazi.nvim",
	event = "VeryLazy",
	dependencies = {
		-- check the installation instructions at
		-- https://github.com/folke/snacks.nvim
		"folke/snacks.nvim",
	},
	keys = {
		-- 👇 in this section, choose your own keymappings!
		{
			"<leader>E",
			mode = { "n", "v" },
			"<cmd>Yazi<cr>",
			desc = "Yazi at current file",
		},
		{
			-- Open in the current working directory
			"<leader>e",
			"<cmd>Yazi cwd<cr>",
			desc = "Yazi in working directory",
		},
	},
	---@type YaziConfig | {}
	opts = {
		-- if you want to open yazi instead of netrw, see below for more info
		open_for_directories = false,
		keymaps = {
			show_help = "<f1>",
		},
	},
	-- 👇 if you use `open_for_directories=true`, this is recommended
	init = function()
		-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
		-- vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
	end,
}
