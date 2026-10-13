return {
  {
    "mason-org/mason.nvim",
    lazy = false,
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,

    dependencies = {
      "mason-org/mason.nvim",
    },

    config = function()
      -- Kotlin: use the Homebrew executable.
      vim.lsp.config("kotlin_lsp", {
        cmd = { "kotlin-lsp", "--stdio" },
        single_file_support = false,
      })

      -- Enable Java and Kotlin language servers.
      vim.lsp.enable("jdtls")
      vim.lsp.enable("kotlin_lsp")
    end,
  },
}
