return {
	"folke/snacks.nvim",
	opts = {
		scroll = { enabled = false },

		picker = {
			formatters = {
				file = {
					filename_first = true,
				},
			},

			keys = {
				{
					"<leader>/",
					function()
						Snacks.picker.lines()
					end,
					desc = "Buffer Lines",
				},
				{
					"<leader><space>",
					function()
						Snacks.picker.buffers()
					end,
					desc = "Buffers",
				},
				{
					"<leader>sb",
					function()
						Snacks.picker.grep_buffers()
					end,
					desc = "Grep Open Buffers",
				},
				{
					"<leader>fa",
					LazyVim.pick("files", { hidden = true, ignored = true, root = false }),
					desc = "Find All Files (cwd, h+i)",
				},
				{ "<leader>f.", LazyVim.pick("oldfiles"), desc = "Recent files" },
				{ "<leader>sB", false },
				{ "<leader>,", false },
				{ "<leader>fb", false },
				{ "<leader>fr", false },
				{ "<leader>fR", false },
				{ "<leader>sR", false },
			},
		},
	},
	keys = {
		{
			"<leader>/",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>fa",
			LazyVim.pick("files", { hidden = true, ignored = true, root = false }),
			desc = "Find All Files (cwd, h+i)",
		},

		{ "<leader>f.", LazyVim.pick("oldfiles"), desc = "Recent files" },
		-- decluter whichkey
		{ "<leader>sB", false },
		{ "<leader>,", false },
		{ "<leader>fb", false },
		{ "<leader>fr", false },
		{ "<leader>fR", false },
		{ "<leader>sR", false },
	},
}
