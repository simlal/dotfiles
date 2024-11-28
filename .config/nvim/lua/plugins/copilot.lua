return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				filetypes = {
					markdown = true,
					["*"] = false,
				},
				suggestion = {
					auto_trigger = true,
					keymap = {
						accept_word = "<M-,>",
					},
				},
			})
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- custom keymaps
			vim.keymap.set("n", "<leader>tc", "<cmd>CopilotChatToggle<CR>", { desc = "[C]opilot Chat" }),

			-- markdown render config
			highlight_headers = false,
			separator = "---",
			error_header = "> [!ERROR] Error",

			-- models
			-- model = "o1-mini",
		},
	},
}
