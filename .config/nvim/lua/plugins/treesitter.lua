return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"groovy",
				"html",
				"java",
				"json5",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"vim",
				"vimdoc",
			},
			-- Autoinstall languages that are not installed
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		dependencies = "nvim-treesitter/nvim-treesitter",
		opts = {
			move = {
				enable = true,
				set_jumps = true,
				keys = {
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
						["]A"] = "@parameter.inner",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter-textobjects")
			TS.setup(opts)
			local function attach(buf)
				local ft = vim.bo[buf].filetype
				local moves = opts.move.keys or {}
				for method, keymaps in pairs(moves) do
					for key, query in pairs(keymaps) do
						local queries = type(query) == "table" and query or { query }
						local parts = {}
						for _, q in ipairs(queries) do
							local part = q:gsub("@", ""):gsub("%..*", "")
							-- part = part:sub(1, 1):upper() .. part:sub(2)
							table.insert(parts, part)
						end
						local desc = table.concat(parts, " or ")
						desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
						desc = desc .. (key:sub(2, 2):upper() == key:sub(2, 2) and " End" or " Start")
						vim.keymap.set({ "n", "x", "o" }, key, function()
							require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
						end, { buffer = buf, desc = desc, silent = true })
					end
				end
			end
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					attach(ev.buf)
				end,
			})
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_loaded(buf) then
					attach(buf)
				end
			end
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
}
