return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = true,
        python = true,
        rust = true,
        ["*"] = false,
      },
      keymap = {
        accept_word = "<C-,>",
        next = "<C-]>",
        prev = "<C-[",
      },
    },
  },
}
