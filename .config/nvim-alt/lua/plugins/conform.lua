return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						async = false,
						lsp_fallback = true,
						quiet = false,
						timeout_ms = 3000,
					})
				end,
				mode = { "n", "x" },
				desc = "Format",
			},
			{
				"<leader>cF",
				function()
					require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
				end,
				mode = { "n", "x" },
				desc = "Format injected languages",
			},
		},
		opts = {
			-- notify_on_error = false,
			format_on_save = function(bufnr)
				-- Respect autoformat toggle from usercommand
				if not (vim.g.autoformat or vim.b[bufnr].autoformat) then
					return false
				end
				local disable_filetypes = { c = true, cpp = true, groovy = true, java = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,

			formatters_by_ft = {
				lua = { "stylua" },
				markdown = { "prettier", "markdownlint-cli2", stop_after_first = true },
				sh = { "shfmt", lsp_format = "fallback" },
				java = { "google-java-format", lsp_format = "fallback" },
				http = { "kulala-fmt", lsp_format = "fallback" },
				-- Use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
