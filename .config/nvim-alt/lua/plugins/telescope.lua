return {
	{ -- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ -- If encountering errors, see telescope-fzf-native README for installation instructions
				"nvim-telescope/telescope-fzf-native.nvim",

				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = "make",

				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },

			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				defaults = {
					path_display = { "filename_first" },
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			-- BUG: FIX ME not working!
			local function get_visual_selection()
				local _, ls, cs = unpack(vim.fn.getpos("'<"))
				local _, le, ce = unpack(vim.fn.getpos("'>"))
				local lines = vim.fn.getline(ls, le)

				if #lines == 0 then
					return ""
				end

				lines[#lines] = string.sub(lines[#lines], 1, ce)
				lines[1] = string.sub(lines[1], cs)

				return table.concat(lines, "\n")
			end

			local builtin = require("telescope.builtin")

			-- Search
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help Pages" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Keymaps" })
			vim.keymap.set("n", "<leader>sm", builtin.marks, { desc = "Marks" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
			vim.keymap.set("n", "<leader>sW", function()
				builtin.grep_string({
					cwd = require("telescope.utils").buffer_dir(),
				})
			end, { desc = "Search current Word (buffer dir)" })

			-- BUG: FIX SELECTION
			vim.keymap.set("x", "<leader>sw", function()
				local text = get_visual_selection()
				builtin.grep_string({ search = text })
			end, { desc = "Search selection (root dir)" })
			vim.keymap.set("x", "<leader>sW", function()
				local text = get_visual_selection()
				builtin.grep_string({ search = text, cwd = utils.buffer_dir() })
			end, { desc = "Search selection (buffer dir)" })

			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep (cwd)" })
			vim.keymap.set("n", "<leader>sG", function()
				builtin.live_grep({
					cwd = require("telescope.utils").buffer_dir(),
					prompt_title = "Grep (buffer dir)",
				})
			end, { desc = "Grep (buffer dir)" })

			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>sD", function()
				builtin.diagnostics({
					bufnr = 0,
					prompt_title = "Diagnostics (current buffer)",
				})
			end, { desc = "Diagnostics (current buffer)" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Grep in Open Buffers",
				})
			end, { desc = "Grep Open Buffers" })
			vim.keymap.set("n", "<leader>sa", builtin.autocommands, { desc = "Autocommands" })

			-- Find files
			vim.keymap.set("n", "<leader>fa", function()
				builtin.find_files({
					prompt_title = "All files (hidden/ignored cwd)",
					hidden = true,
					no_ignore = true,
				})
			end, { desc = "All files (hidden/ignored cwd)" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find Files (cwd)" })
			vim.keymap.set("n", "<leader>fF", function()
				builtin.find_files({
					cwd = require("telescope.utils").buffer_dir(),
					prompt_title = "Find files (buffer dir)",
				})
			end, { desc = "Files (buffer dir)" })
			vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git Files" })
			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = "Find Recent Files " })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "  Find existing buffers" })

			vim.keymap.set("n", "<leader>fc", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "Find config file" })

			-- Git integrations keymaps
			vim.keymap.set("n", "<leader>gf", builtin.git_bcommits, { desc = "Git current file history" })
			vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Git branches" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

			-- Misc
			vim.keymap.set("n", "<leader>:", builtin.command_history, { desc = "Command History" })
			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "Fuzzy search (current buf)" })
		end,
	},
}
