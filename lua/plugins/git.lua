return {
  {
    "lewis6991/gitsigns.nvim",

    opts = {},

    keys = {
      {
        "]c",
        function()
          require("gitsigns").nav_hunk("next")
        end,
        desc = "Next Git change",
      },

      {
        "[c",
        function()
          require("gitsigns").nav_hunk("prev")
        end,
        desc = "Previous Git change",
      },

      {
        "<leader>Gp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Preview Git change",
      },

      {
        "<leader>Gs",
        function()
          require("gitsigns").stage_hunk()
        end,
        desc = "Stage Git change",
      },

      {
        "<leader>Gr",
        function()
          require("gitsigns").reset_hunk()
        end,
        desc = "Reset Git change",
      },

      {
        "<leader>Gb",
        function()
          require("gitsigns").blame_line()
        end,
        desc = "Git blame",
      },
    },
  },

  {
    "sindrets/diffview.nvim",

    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },

    keys = {
      {
        "<leader>Gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Git diff",
      },

      {
        "<leader>GD",
        "<cmd>DiffviewClose<cr>",
        desc = "Close Git diff",
      },

      {
        "<leader>Gh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "File history",
      },
    },
  },
}
