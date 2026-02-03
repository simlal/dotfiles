return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	opts = {
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
		heading = {
			sign = false,
			icons = {},
		},
		checkbox = {
			enabled = false,
		},

		file_types = { "markdown", "norg", "rmd", "org", "codecompanion", "asciidoc", "copilot-chat" },
	},
	config = function(_, opts)
		require("render-markdown").setup(opts)
	end,
}
