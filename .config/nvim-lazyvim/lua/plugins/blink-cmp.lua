return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<C-space>"] = {},
      ["<C-e>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-q>"] = { "hide", "fallback" },
      ["<CR>"] = {},
    },
  },
}
