return {
	"linux-cultist/venv-selector.nvim",
	ft = "python",
	cmd = "VenvSelect",
	opts = {
		options = {
			notify_user_on_venv_activation = true,
		},
	},
	keys = {
		{ "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
	},
}
