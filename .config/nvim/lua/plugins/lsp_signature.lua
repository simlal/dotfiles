-- helper func for max height
local function set_max_height_floating_win(fraction)
	local current_win_height = vim.api.nvim_win_get_height(0)
	local max_height = math.ceil(current_win_height * fraction)
	return max_height
end
return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	opts = {
		bind = true,
		handler_opts = {
			border = "rounded",
		},
		hint_inline = function()
			return true
		end,
		hint_prefix = " ",

		-- max_height = set_max_height_floating_win(0.2),
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
