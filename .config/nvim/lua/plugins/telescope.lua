-- TODO: TEST
-- NOTE
-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin
return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
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
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use Telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of `help_tags` options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- Telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			--
			defaults = {
				layout_config = {
					horizontal = {
						preview_cutoff = 10,
						preview_width = 0.5,
					},
				},
			},
			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>s?", builtin.help_tags, { desc = "[?] Help" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[K]eymaps" })
		vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[F]iles" })
		vim.keymap.set("n", "<leader>sa", function()
			builtin.find_files({
				find_command = {
					"fd",
					"--type",
					"f",
					"--hidden",
					"--follow",
					"--no-ignore",
					"-E",
					".git/*",
				},
			})
		end, { desc = "[A]ll files (incl. hidden)" })
		vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[.] Recent Files" })
		vim.keymap.set("n", "<leader>ss", builtin.grep_string, { desc = "Grep current Word [S]election" })
		vim.keymap.set("n", "<leader>sw", builtin.live_grep, { desc = "Grep in [W]orkspace" })
		vim.keymap.set("n", "<leader>ds", builtin.diagnostics, { desc = "[D]iagnostics" })
		-- vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[R]esume" })
		vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find Existing Buffers" })
		-- git specific search remaps
		vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "[G]it Files" })
		vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Search [S]tatus" })
		vim.keymap.set("n", "<leader>gc", builtin.git_bcommits, { desc = "Search [c]ommits Buffer" })
		vim.keymap.set("n", "<leader>gC", builtin.git_commits, { desc = "Search [C]ommits Workspace" })
		-- current files search
		vim.keymap.set("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 5,
				previewer = true,
				layout_config = {
					width = 0.8,
					height = 0.3,
					preview_cutoff = 0, -- Ensure the previewer is always displayed
				},
			}))
		end, { desc = "[/] Fuzzy Search Buffer" })
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[/] Grep in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = "~/dotfiles/.config/nvim/" })
		end, { desc = "[S]earch [N]eovim files" })
	end,
}
