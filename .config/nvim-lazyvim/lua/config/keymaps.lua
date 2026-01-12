-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Resize window using <ctrl> arrow keys
LazyVim.safe_keymap_set("n", "<C-Up>", "<cmd>resize +5<cr>", { desc = "Increase Window Height" })
LazyVim.safe_keymap_set("n", "<C-Down>", "<cmd>resize -5<cr>", { desc = "Decrease Window Height" })
LazyVim.safe_keymap_set("n", "<C-Left>", "<cmd>vertical resize -3<cr>", { desc = "Decrease Window Width" })
LazyVim.safe_keymap_set("n", "<C-Right>", "<cmd>vertical resize +3<cr>", { desc = "Increase Window Width" })
