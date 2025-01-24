vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- [[ Disable format-on-save in conform ]]
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

-- Function to get the current YAML schema
local function get_schema()
	local schema = require("yaml-companion").get_buf_schema(0)
	if schema.result[1].name == "none" then
		return "No schema applied"
	end
	return schema.result[1].name
end

-- Create a custom command to show the current schema
vim.api.nvim_create_user_command("YamlSchemaCurrent", function()
	local schema_name = get_schema()
	print("Current YAML schema: " .. schema_name)
end, {})

-- Custom command to trigger telescope with yaml_schema (yaml-companion)
vim.api.nvim_create_user_command("YamlSchemaPick", function()
	vim.cmd("Telescope yaml_schema")
end, {})
