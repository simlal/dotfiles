return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()

			require("nvim-dap-virtual-text").setup({
				-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
						return "*****"
					end

					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			-- init adapters
			if not dap.adapters then
				dap.adapters = {}
			end

			dap.adapters["probe-rs-debug"] = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.expand("$HOME/.nix-profile/bin/probe-rs"),
					args = { "dap-server", "--port", "${port}" },
				},
			}
			-- Connect the probe-rs-debug with rust files. Configuration of the debugger is done via project_folder/.vscode/launch.json
			require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust" }

			-- Set up of handlers for RTT and probe-rs messages.
			-- In addition to nvim-dap-ui I write messages to a probe-rs.log in project folder
			-- If RTT is enabled, probe-rs sends an event after init of a channel. This has to be confirmed or otherwise probe-rs wont sent the rtt data.
			dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(
				session,
				body
			)
				local utils = require("dap.utils")
				utils.notify(
					string.format(
						'probe-rs: Opening RTT channel %d with name "%s"!',
						body.channelNumber,
						body.channelName
					)
				)
				local file = io.open("probe-rs.log", "a")
				if file then
					file:write(
						string.format(
							'%s: Opening RTT channel %d with name "%s"!\n',
							os.date("%Y-%m-%d-T%H:%M:%S"),
							body.channelNumber,
							body.channelName
						)
					)
				end
				if file then
					file:close()
				end
				session:request("rttWindowOpened", { body.channelNumber, true })
			end

			-- After confirming RTT window is open, we will get rtt-data-events.
			-- I print them to the dap-repl, which is one way and not separated.
			-- If you have better ideas, let me know.
			dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
				local message = string.format(
					"%s: RTT-Channel %d - Message: %s",
					os.date("%Y-%m-%d-T%H:%M:%S"),
					body.channelNumber,
					body.data
				)
				local repl = require("dap.repl")
				repl.append(message)
				local file = io.open("probe-rs.log", "a")
				if file then
					file:write(message)
				end
				if file then
					file:close()
				end
			end

			-- Probe-rs can send messages, which are handled with this listener.
			dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
				local message = string.format("%s: probe-rs message: %s", os.date("%Y-%m-%d-T%H:%M:%S"), body.message)
				local repl = require("dap.repl")
				repl.append(message)
				local file = io.open("probe-rs.log", "a")
				if file then
					file:write(message)
				end
				if file then
					file:close()
				end
			end

			-- keymaps
			vim.keymap.set("n", "<leader>tb", ui.toggle, { noremap = true, desc = "DAP de[B]ugger" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle [B]reakpoint" })
			vim.keymap.set("n", "<space>dg", dap.run_to_cursor, { desc = "[G] Run to cursor" })

			local icons = {
				continue = "▶️",
				step_into = "↘️",
				step_over = "➡️",
				step_out = "↩️",
				step_back = "⬅️",
				restart = "🔄",
			}
			vim.keymap.set("n", "<leader>d<F1>", dap.continue, { desc = icons.continue .. " Continue" })
			vim.keymap.set("n", "<leader>d<F2>", dap.step_into, { desc = icons.step_into .. " Step Into" })
			vim.keymap.set("n", "<leader>d<F3>", dap.step_over, { desc = icons.step_over .. " Step Over" })
			vim.keymap.set("n", "<leader>d<F4>", dap.step_out, { desc = icons.step_out .. " Step Out" })
			vim.keymap.set("n", "<leader>d<F5>", dap.step_back, { desc = icons.step_back .. " Step Back" })
			vim.keymap.set("n", "<leader>d<F12>", dap.restart, { desc = icons.restart .. " Restart" })
			-- dap-ui
			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
