local map = vim.keymap.set

--
-- Saving
--

map("n", "<leader>w", "<cmd>write<cr>", {
  desc = "Save file",
})

--
-- Searching
--
-- Keep your original:
-- Space      -> /
-- Ctrl-Space -> ?
--

map("n", "<Space>", "/", {
  desc = "Search forward",
})

map("n", "<C-Space>", "?", {
  desc = "Search backward",
})

map("n", "<Esc>", "<cmd>nohlsearch<cr>", {
  desc = "Clear search highlight",
})

--
-- Window movement
--

map("n", "<C-h>", "<C-w>h", {
  desc = "Window left",
})

map("n", "<C-j>", "<C-w>j", {
  desc = "Window down",
})


map("n", "<C-k>", "<C-w>k", {
  desc = "Window up",
})

map("n", "<C-l>", "<C-w>l", {
  desc = "Window right",
})

--
-- Buffer navigation
--

map("n", "<leader>l", "<cmd>bnext<cr>", {
  desc = "Next buffer",
})

map("n", "<leader>h", "<cmd>bprevious<cr>", {
  desc = "Previous buffer",
})

--
-- Tabs
--

map("n", "<leader>tn", "<cmd>tabnew<cr>", {
  desc = "New tab",
})

map("n", "<leader>to", "<cmd>tabonly<cr>", {
  desc = "Close other tabs",
})

map("n", "<leader>tc", "<cmd>tabclose<cr>", {
  desc = "Close tab",
})

map("n", "<leader>t<leader>", "<cmd>tabnext<cr>", {
  desc = "Next tab",
})

--
-- Working directory
--

map("n", "<leader>cd", function()
  local dir = vim.fn.expand("%:p:h")

  if dir ~= "" then
    vim.cmd.cd(vim.fn.fnameescape(dir))
    print(vim.fn.getcwd())
  end
end, {
  desc = "CD to file directory",
})

--
-- Your custom 0 behavior
--

map({ "n", "x" }, "0", "^", {
  desc = "First non-blank character",
})

--
-- Move lines with Alt-j / Alt-k
--

map("n", "<M-j>", ":move .+1<cr>==", {
  silent = true,
  desc = "Move line down",
})

map("n", "<M-k>", ":move .-2<cr>==", {
  silent = true,
  desc = "Move line up",
})

map("x", "<M-j>", ":move '>+1<cr>gv=gv", {
  silent = true,
  desc = "Move selection down",
})

map("x", "<M-k>", ":move '<-2<cr>gv=gv", {
  silent = true,
  desc = "Move selection up",
})

--
-- Spell checking
--

map("n", "<leader>ss", "<cmd>setlocal spell!<cr>", {
  desc = "Toggle spell check",
})

map("n", "<leader>sn", "]s", {
  desc = "Next spelling error",
})

map("n", "<leader>sp", "[s", {
  desc = "Previous spelling error",
})

map("n", "<leader>sa", "zg", {
  desc = "Add word to dictionary",
})

map("n", "<leader>s?", "z=", {
  desc = "Spelling suggestions",
})

--
-- Keep your scratch files
--

map("n", "<leader>q", "<cmd>edit ~/buffer<cr>", {
  desc = "Open scratch buffer",
})

map("n", "<leader>x", "<cmd>edit ~/buffer.md<cr>", {
  desc = "Open Markdown scratch buffer",
})


--
--Jump between open files
--
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("bufferline").go_to(i, true)
  end, {
    desc = "Go to buffer " .. i,
  })
end

--
-- Them picker
--
vim.keymap.set("n", "<leader>ut", function()
  local themes = {
    "tokyonight-moon",
    "tokyonight-storm",
    "tokyonight-night",
    "catppuccin-mocha",
    "catppuccin-macchiato",
    "catppuccin-frappe",
    "catppuccin-latte",
  }

  vim.ui.select(themes, {
    prompt = "Choose colorscheme",
  }, function(choice)
    if choice then
      vim.cmd.colorscheme(choice)
    end
  end)
end, {
  desc = "Switch colorscheme",
})

-- =====================================
-- LSP navigation
-- =====================================

local map = vim.keymap.set

-- Go directly to definition.
map("n", "gd", vim.lsp.buf.definition, {
  desc = "Go to definition",
})

-- Go to declaration.
map("n", "gD", vim.lsp.buf.declaration, {
  desc = "Go to declaration",
})

-- Find references using Snacks.
map("n", "gr", function()
  Snacks.picker.lsp_references()
end, {
  nowait = true,
  desc = "Find references",
})

-- Find implementations.
map("n", "gI", function()
  Snacks.picker.lsp_implementations()
end, {
  desc = "Go to implementation",
})

-- Find type definition.
map("n", "gy", function()
  Snacks.picker.lsp_type_definitions()
end, {
  desc = "Go to type definition",
})

-- Documentation.
map("n", "K", vim.lsp.buf.hover, {
  desc = "Hover documentation",
})

-- Rename across project.
map("n", "<leader>rn", vim.lsp.buf.rename, {
  desc = "Rename symbol",
})

-- Available refactorings / quick fixes.
map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, {
  desc = "Code actions",
})

-- Search symbols in current file.
map("n", "<leader>Si", function()
  Snacks.picker.lsp_symbols()
end, {
  desc = "Document symbols",
})

-- Search symbols across project.
map("n", "<leader>Sw", function()
  Snacks.picker.lsp_workspace_symbols()
end, {
  desc = "Workspace symbols",
})

-- Navigate diagnostics.
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end, {
  desc = "Next diagnostic",
})

map("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end, {
  desc = "Previous diagnostic",
})
