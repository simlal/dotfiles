return {
	{ -- Autocompletion
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		version = "1.*",
		dependencies = {
			-- Snippet Engine
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					-- Build Step is needed for regex support in snippets.
					-- This step is not supported in many windows environments.
					-- Remove the below condition to re-enable on windows.
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				opts = {},
			},
			"folke/lazydev.nvim",
			{ "fang2hou/blink-copilot" },
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
				["<C-space>"] = {},
				["<C-e>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-q>"] = { "hide", "fallback" },
			},

			appearance = {
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 200 },
			},

			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				per_filetype = {
					markdown = { inherit_defaults = true, "copilot" },
					asciidoc = { inherit_defaults = true, "copilot" },
					-- python = { inherit_defaults = true, "copilot" },
				},
				providers = {
					copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true },
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
					path = {
						enabled = function()
							return vim.bo.filetype ~= "copilot-chat"
						end,
					},
				},
			},

			snippets = { preset = "luasnip" },

			fuzzy = { implementation = "prefer_rust_with_warning" },

			-- Shows a signature help window while you type arguments for a function
			signature = { enabled = true },
		},
	},
}
-- vim: ts=2 sts=2 sw=2 et
