-- Keep my existing leader.
vim.g.mapleader = ","
vim.g.maplocalleader = ","

local opt = vim.opt

-- Automatically notice files changed outside Neovim.
opt.autoread = true

-- UI
opt.number = true
opt.scrolloff = 7
opt.showmatch = true
opt.wrap = true
opt.signcolumn = "yes"
opt.termguicolors = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Indentation: keep my existing 2-space setup.
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true

-- System clipboard.
opt.clipboard = "unnamedplus"

-- Persistent undo.
opt.undofile = true

-- Sensible split behavior.
opt.splitright = true
opt.splitbelow = true

-- Highlight the line currently being edited.
vim.opt.cursorline = true

-- One global statusline.
vim.opt.laststatus = 3

-- More visible splits.
vim.opt.fillchars:append({
  vert = "│",
})

-- Keep true-color highlighting.
vim.opt.termguicolors = true
