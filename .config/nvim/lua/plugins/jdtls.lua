return {
	"mfussenegger/nvim-jdtls",
	dependencies = { "folke/which-key.nvim" },
	ft = { "java" },
	opts = function()
		local cmd = { vim.fn.exepath("jdtls") }

		local mason_path = vim.fn.expand("$MASON")
		if mason_path ~= "$MASON" and mason_path ~= "" then
			local lombok_jar = mason_path .. "/share/jdtls/lombok.jar"
			if vim.loop.fs_stat(lombok_jar) then
				table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
			end
		end

		return {
			root_dir = function(path)
				return vim.fs.root(path, { "mvnw", "gradlew", "pom.xml", "build.gradle" })
			end,

			project_name = function(root_dir)
				return root_dir and vim.fs.basename(root_dir)
			end,

			jdtls_config_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
			end,
			jdtls_workspace_dir = function(project_name)
				return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
			end,

			cmd = cmd,
			full_cmd = function(opts)
				local fname = vim.api.nvim_buf_get_name(0)
				local root_dir = opts.root_dir(fname)
				local project_name = opts.project_name(root_dir)
				local cmd = vim.deepcopy(opts.cmd)
				if project_name then
					vim.list_extend(cmd, {
						"-configuration",
						opts.jdtls_config_dir(project_name),
						"-data",
						opts.jdtls_workspace_dir(project_name),
					})
				end
				return cmd
			end,

			settings = {
				java = {
					configuration = {
						runtimes = {
							{ name = "JavaSE-11", path = "/usr/lib/jvm/jdk11" },
							{ name = "JavaSE-21", path = "/usr/lib/jvm/jdk21", default = true },
						},
					},
					inlayHints = { parameterNames = { enabled = "all" } },
					format = { insertSpaces = false, tabSize = 4 },
				},
			},
		}
	end,
	config = function(_, opts)
		local function attach_jdtls()
			local fname = vim.api.nvim_buf_get_name(0)
			if fname == "" or vim.bo.buftype ~= "" then
				return
			end

			local config = {
				cmd = opts.full_cmd(opts),
				root_dir = opts.root_dir(fname),
				init_options = {
					bundles = {},
					extendedClientCapabilities = {
						progressReportProvider = true,
						classFileContentsSupport = true,
						generateConstructorsPromptSupport = true,
						generateToStringPromptSupport = true,
						hashCodeEqualsPromptSupport = true,
						overrideMethodsPromptSupport = true,
						advancedOrganizeImportsSupport = true,
						executeClientCommandSupport = true,
					},
				},
				settings = opts.settings,
				capabilities = require("blink.cmp").get_lsp_capabilities(),
			}

			require("jdtls").start_or_attach(config)
		end

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "java",
			callback = attach_jdtls,
		})

		-- Keybinds after LspAttach
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if client and client.name == "jdtls" then
					local wk = require("which-key")
					wk.add({
						{
							mode = "n",
							buffer = args.buf,
							{ "<leader>cx", group = "extract" },
							{ "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
							{ "<leader>cxc", require("jdtls").extract_constant, desc = "Extract Constant" },
							{ "<leader>co", require("jdtls").organize_imports, desc = "Organize Imports" },
						},
					})
				end
			end,
		})

		attach_jdtls()
	end,
}
