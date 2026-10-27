return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    opts = {
      explorer = {
        enabled = true,
      },

      picker = {
        enabled = true,
        sources = {
          explorer = {
            hidden = true,
          },
        },
      },

      input = {
        enabled = true,
      },

      quickfile = {
        enabled = true,
      },

      bigfile = {
        enabled = true,
      },
    },

    keys = {
      --
      -- Explorer
      --

      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "File explorer",
      },

      --
      -- File search
      --

      {
        "<leader>f",
        function()
          Snacks.picker.files()
        end,
        desc = "Find file",
      },

      --
      -- Keep your old ,g concept:
      -- old: ,g -> Ag
      -- new: ,g -> ripgrep
      --

      {
        "<leader>g",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep project",
      },

      --
      -- Replace your custom Bclose.
      --

      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete buffer",
      },

      {
        "<leader>ba",
        function()
          Snacks.bufdelete.all()
        end,
        desc = "Delete all buffers",
      },
    },
  },

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
}
