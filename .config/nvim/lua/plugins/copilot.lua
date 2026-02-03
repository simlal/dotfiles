return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			filetypes = {
				markdown = true,
				asciidoc = true,
				python = false,
				javascript = false,
				typescript = false,
				yaml = false,
				toml = false,
				["*"] = false,
			},
			keymap = {
				accept_word = "<C-,>",
				next = "<C-]>",
				prev = "<C-[",
			},
		},
	},
}
