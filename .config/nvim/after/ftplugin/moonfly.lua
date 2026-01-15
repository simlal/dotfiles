local custom_highlight = vim.api.nvim_create_augroup("MoonflyOverrides", {})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "moonfly",
	group = custom_highlight,
	callback = function()
		local colors = require("moonfly").palette

		-- Python lsp override
		vim.api.nvim_set_hl(0, "@lsp.type.variable.python", { fg = colors.cyan })
		vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = colors.cyan })
	end,
})
