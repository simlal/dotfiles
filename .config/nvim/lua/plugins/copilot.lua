return {
	{
		"zbirenbaum/copilot.lua",
		opts = {
			filetypes = {
				markdown = true,
				asciidoc = true,
				python = true,
				groovy = true,
				java = true,
				javascript = false,
				typescript = false,
				yaml = false,
				toml = false,
				sh = true,
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
