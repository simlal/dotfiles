return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    auto_insert_mode = false,
    mappings = {
      close = {
        normal = "q",
        insert = "<C-q>", -- remove default binding for Ctrl+C
      },
      reset = {
        normal = "<M-d>", -- replace Ctrl+L with Meta+D
        insert = "<M-d>",
      },
      -- other mappings...
    },
  },
}
