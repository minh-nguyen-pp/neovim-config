local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },

  checker = {
    enabled = true,
    notify = false,
  },

  change_detection = {
    notify = false,
  },
})

-- Safely load the preferred colorscheme.
local ok = pcall(vim.cmd.colorscheme, "catppuccin-mocha")

if not ok then
  pcall(vim.cmd.colorscheme, "tokyonight-moon")
end
