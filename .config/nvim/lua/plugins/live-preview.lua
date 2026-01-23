return {
	"brianhuster/live-preview.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "<leader>cps", "<cmd>LivePreview start<cr>", desc = "Start live preview" },
		{ "<leader>cpc", "<cmd>LivePreview close<cr>", desc = "Close live preview" },
		{ "<leader>fp", "<cmd>LivePreview pick<cr>", desc = "Files live preview (cwd)" },
	},
}
