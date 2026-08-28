return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        markdown = false,
        python = false,
        javascript = false,
        typescript = false,
        yaml = false,
        toml = false,
        sql = false,
        sh = false,
        hcl = false,
        lua = false,
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
