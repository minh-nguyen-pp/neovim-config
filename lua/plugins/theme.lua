return {
  -- TokyoNight
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    lazy = false,
    priority = 1000,

    opts = {
      style = "moon",
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        sidebars = "dark",
        floats = "dark",
      },
    },
  },

  -- Catppuccin
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,

    opts = {
      flavour = "mocha",
      transparent_background = false,
      auto_integrations = true,
    },
  },
}
