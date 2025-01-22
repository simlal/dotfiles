return {
	{

		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "" .. desc })
					end

					map("gd", require("telescope.builtin").lsp_definitions, "lsp: [G]oto [D]efinition")
					map("gr", require("telescope.builtin").lsp_references, "lsp: [G]oto [R]eferences")
					map("gI", require("telescope.builtin").lsp_implementations, "lsp: [G]oto [I]mplementation")
					map("gT", require("telescope.builtin").lsp_type_definitions, "lsp: Type [D]efinition")
					map("gD", vim.lsp.buf.declaration, "lsp: [G]oto [D]eclaration")
					map("<leader>c/", require("telescope.builtin").lsp_document_symbols, "[/] Search Buffer Symbols")
					map(
						"<leader>cw",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"Search [W]orkspace Symbols"
					)
					map("<leader>cr", vim.lsp.buf.rename, "[R]ename")
					map("<leader>ca", vim.lsp.buf.code_action, "[A]ction", { "n", "x" })

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your
					-- code, if the language server you are using supports them
					--
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>ch", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay [H]ints")
					end
				end,
			})

			-- Setup Neovim LSP configuration
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			local servers = {
				bashls = {},
				dockerls = {},
				pyright = {
					analysis = {
						typeCheckingMode = "standard",
					},
				},
				eslint = {},
				ts_ls = {},
				nixd = {},
				marksman = {},
				sqls = {},
				cmake = {},
				clangd = {},
				rust_analyzer = {},
				yamlls = require("yaml-companion").setup({
					lspconfig = {
						flags = {
							debounce_text_changes = 150,
						},
						settings = {
							redhat = { telemetry = { enabled = false } },
							yaml = {
								validate = true,
								format = { enable = true },
								hover = true,
								schemaStore = {
									enable = true,
									url = "https://www.schemastore.org/api/json/catalog.json", -- Ensure this URL is active
								},
								schemaDownload = { enable = true },
								schemas = {}, -- Can add specific schemas here if needed
								trace = { server = "debug" },
							},
						},
					},
				}),
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}

			for lsp, config in pairs(servers) do
				config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, config.capabilities or {})
				lspconfig[lsp].setup(config)
			end
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			-- log_level = vim.log.levels.DEBUG, -- Enable debugging logs
			notify_on_error = true,
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable "format_on_save lsp_fallback" for languages that don'tconf
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
			formatters = {
				prettier = {
					timeout_ms = 3000,
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform can also run multiple formatters sequentially
				python = {
					-- To fix auto-fixable lint errors.
					"ruff_fix",
					-- To run the Ruff formatter.
					"ruff_format",
					-- To organize the imports.
					"ruff_organize_imports",
				},
				javascript = { "prettier" },
				typescript = { "prettier" },
				nix = { "alejandra" },
				markdown = { "prettier" },
				bash = { "shellcheck" },
				sh = { "shfmt" },
				sql = { "sql_formatter" },
				mysql = { "sql_formatter" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				json = { "prettier" },
				yaml = { "yamlfmt" },
				--
				-- You can use 'stop_after_first' to run the first available formatter from the list
				-- javascript = { "prettierd", "prettier", stop_after_first = true },
			},
		},
	},
}
