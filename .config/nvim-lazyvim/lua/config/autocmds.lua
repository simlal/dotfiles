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

-- commentstring for sql files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		vim.bo.commentstring = "-- %s"
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "groovy",
	callback = function()
		vim.bo.expandtab = false
		vim.bo.tabstop = 2
		vim.bo.softtabstop = 2
		vim.bo.shiftwidth = 2
	end,
})

-- FastCmpModeToggle for blink.cmp
local blink = require("blink.cmp")
local fast_mode_enabled = false

-- Save your normal sources so you can restore them
local normal_sources = { "lsp", "path", "snippets", "buffer" }

local function enable_fast_mode()
	blink.setup({
		completion = { keyword_length = 2, autocomplete = false },
		sources = { default = { "lsp", "path" } },
	})
	fast_mode_enabled = true
	vim.notify("Blink Fast Mode: ON", vim.log.levels.INFO)
end

local function disable_fast_mode()
	blink.setup({
		completion = { keyword_length = 1, autocomplete = true },
		sources = { default = normal_sources },
	})
	fast_mode_enabled = false
	vim.notify("Blink Fast Mode: OFF", vim.log.levels.INFO)
end

-- Manual toggle command
vim.api.nvim_create_user_command("FastCmpModeToggle", function()
	if fast_mode_enabled then
		disable_fast_mode()
	else
		enable_fast_mode()
	end
end, {})

-- Auto‑enable fast mode for large files (>1MB)
vim.api.nvim_create_autocmd("BufReadPre", {
	group = vim.api.nvim_create_augroup("fast_cmp_mode", { clear = true }),
	callback = function(args)
		local size = vim.fn.getfsize(args.file)
		if size > 1024 * 1024 then
			enable_fast_mode()
		end
	end,
	desc = "Enable Blink Fast Mode for large files",
})
