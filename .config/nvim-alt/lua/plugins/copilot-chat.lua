return {
	"CopilotC-Nvim/CopilotChat.nvim",

	opts = function()
		local user = vim.env.USER or "User"
		user = user:sub(1, 1):upper() .. user:sub(2)

		return {
			auto_insert_mode = false,

			mappings = {
				close = {
					normal = "q",
					insert = "<C-q>",
				},
				reset = {
					normal = "<M-d>",
					insert = "<M-d>",
				},
			},

			headers = {
				user = "  " .. user .. " ",
				assistant = "🤖  Copilot ",
				tool = "🔧  Tool ",
			},

			window = {
				width = 0.4,
			},

			model = "claude-sonnet-4",

			providers = {
				github_models = {
					disabled = false,
				},
			},
		}
	end,

	keys = {
		{ "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },

		{ "<leader>a", "", desc = "+ai", mode = { "n", "x" } },

		{
			"<leader>aa",
			function()
				return require("CopilotChat").toggle()
			end,
			desc = "Toggle (CopilotChat)",
			mode = { "n", "x" },
		},

		{
			"<leader>ax",
			function()
				return require("CopilotChat").reset()
			end,
			desc = "Clear (CopilotChat)",
			mode = { "n", "x" },
		},

		{
			"<leader>ap",
			function()
				require("CopilotChat").select_prompt()
			end,
			desc = "Prompt Actions (CopilotChat)",
			mode = { "n", "x" },
		},
	},

	config = function(_, opts)
		local chat = require("CopilotChat")

		vim.api.nvim_create_autocmd("BufEnter", {
			pattern = "copilot-chat",
			callback = function()
				vim.opt_local.relativenumber = false
				vim.opt_local.number = false
			end,
		})

		chat.setup(opts)
	end,
}
