return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = true,
        python = false,
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
