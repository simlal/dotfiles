return {
	"folke/noice.nvim",
	lazy = false,

	dependencies = {
		"MunifTanjim/nui.nvim",
		-- "rcarriga/nvim-notify",
	},

	keys = {
		{ "<leader>m", group = "messages" },

		{
			"<leader>ml",
			function()
				require("noice").cmd("last")
			end,
			desc = "Last Message",
		},
		{
			"<leader>mh",
			function()
				require("noice").cmd("history")
			end,
			desc = "Messages History",
		},
		{
			"<leader>ma",
			function()
				require("noice").cmd("all")
			end,
			desc = "All Messages",
		},
		{
			"<leader>md",
			function()
				require("noice").cmd("dismiss")
			end,
			desc = "Dismiss All",
		},
		{
			"<leader>ms",
			function()
				require("noice").cmd("pick")
			end,
			desc = "Search Messages",
		},
	},

	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},

		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
			inc_rename = false,
			lsp_doc_border = false,
		},

		routes = {
			{
				view = "notify",
				filter = { event = "msg_showmode" },
			},
		},

		cmdline = {
			view = "cmdline",
		},

		views = {
			mini = {
				timeout = 3000,
				position = { row = -1, col = 0 },
				size = {
					width = "auto",
					height = "auto",
					max_height = 10,
				},
				zindex = 60,
				win_options = {
					winblend = 0,
				},
			},
		},
	},

	config = function(_, opts)
		require("noice").setup(opts)
	end,
}
