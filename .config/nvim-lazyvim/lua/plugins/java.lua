return {
	{
		"mfussenegger/nvim-jdtls",
		opts = {
			root_dir = function(path)
				return vim.fs.root(path, { "pom.xml", "build.gradle", "gradlew" })
			end,
		},
	},
}
