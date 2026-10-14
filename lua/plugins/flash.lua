return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = { enabled = false },
        char = { enabled = false },
      },
      search = {
        multi_window = true,
      },
    },
    keys = {
      {
        "<leader>,w",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "<leader>,t",
        mode = { "n", "x", "o" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Tree-sitter",
      },
    },
  },
}
