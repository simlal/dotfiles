return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	opts = {
		bind = true,
		handler_opts = {
			border = "rounded",
		},
		hint_inline = function()
			return false
		end,
		hint_prefix = " ",
		toggle_key = "<C-k>", -- Set the toggle key
		-- max_height = set_max_height_floating_win(0.2),
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
		-- Toggle floating window in insert mode
		-- vim.keymap.set("i", "<C-k>", function() require("lsp_signature").toggle_float_win()
		-- end, { silent = true, noremap = true, desc = "Toggle Signature in Insert Mode" })
	end,
}
