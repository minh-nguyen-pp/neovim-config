return {
  {
    "nvim-lualine/lualine.nvim",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      options = {
        theme = "tokyonight",
        globalstatus = true,

        component_separators = {
          left = "│",
          right = "│",
        },

        section_separators = {
          left = "",
          right = "",
        },
      },

      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { "filename" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
