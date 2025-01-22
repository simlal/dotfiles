return {
	{
		"someone-stole-my-name/yaml-companion.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			-- Load the telescope extension for YAML schema
			require("telescope").load_extension("yaml_schema")
		end,
	},
}
