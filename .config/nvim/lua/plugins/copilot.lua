return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = true,
        python = true,
        javascript = true,
        typescript = false,
        yaml = false,
        toml = false,
        sql = true,
        sh = true,
        hcl = true,
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
