-- Function to get the current YAML schema
-- local function get_schema()
--   local schema = require("yaml-companion").get_buf_schema(0)
--   if schema.result[1].name == "none" then
--     return "No schema applied"
--   end
--   return schema.result[1].name
-- end
--
-- -- Create a custom command to show the current schema
-- vim.api.nvim_create_user_command("YamlSchemaCurrent", function()
--   local schema_name = get_schema()
--   print("Current YAML schema: " .. schema_name)
-- end, {})
--
-- -- Custom command to trigger telescope with yaml_schema (yaml-companion)
-- vim.api.nvim_create_user_command("YamlSchemaPick", function()
--   vim.cmd("Telescope yaml_schema")
-- end, {})
--
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "o", "r" }) -- removes auto-comment on o/O and Enter
	end,
	group = vim.api.nvim_create_augroup("mygroup", { clear = true }),
	desc = "Disable auto-commenting on new lines",
})
