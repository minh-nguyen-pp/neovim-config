return {
  {
    "nvim-treesitter/nvim-treesitter",

    lazy = false,

    build = ":TSUpdate",

    config = function()
      local treesitter =
        require("nvim-treesitter")

      treesitter.install({
        "lua",
        "vim",
        "vimdoc",

        "java",
        "kotlin",

        "bash",
        "json",
        "yaml",
        "toml",

        "markdown",
        "markdown_inline",

        "gitcommit",
        "gitignore",
      })

      vim.api.nvim_create_autocmd(
        "FileType",
        {
          pattern = {
            "lua",
            "vim",
            "java",
            "kotlin",
            "bash",
            "json",
            "yaml",
            "toml",
            "markdown",
            "gitcommit",
          },

          callback = function()
            vim.treesitter.start()
          end,
        }
      )
    end,
  },
}
