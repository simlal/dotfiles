return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>/",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader><space>",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>sb",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>fa",
      LazyVim.pick("files", { hidden = true, ignored = true }),
      desc = "Find All Files (h+i, Root Dir)",
    },
    -- decluter whichkey
    { "<leader>sB", false },
    { "<leader>,", false },
    { "<leader>fb", false },
  },
}
