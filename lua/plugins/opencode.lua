-- The directory where this Neovim instance started.
-- Launch Neovim from your worktree root.
local cwd = vim.fn.getcwd()

-- OpenCode v2 discovers or starts the shared background service.
-- Each Neovim keeps its own TUI, without allocating a private server.
local cmd = "opencode"

-- Shared options ensure Snacks reuses the same terminal.
local terminal_opts = {
  cwd = cwd,
  count = 1,

  win = {
    position = "right",
    width = 0.4,
    enter = true,
  },
}

-- Open the managed terminal without spawning a duplicate.
local function ensure_opencode()
  local terminal = Snacks.terminal.get(cmd, {
    cwd = cwd,
    count = 1,
    create = false,
  })

  if terminal then
    terminal:show()
    return
  end

  Snacks.terminal.open(cmd, terminal_opts)
end

-- Focus the terminal; hide it if already focused.
local function toggle_opencode()
  Snacks.terminal.focus(cmd, terminal_opts)
end

return {
  {
    "nickjvandyke/opencode.nvim",

    -- main supports the OpenCode v2 API; stable v1 tags do not.
    branch = "main",
    version = false,

    dependencies = {
      "folke/snacks.nvim",
    },

    keys = {
      {
        "<leader>ot",
        toggle_opencode,
        mode = "n",
        desc = "Focus/toggle OpenCode",
      },

      {
        "<leader>oy",
        function()
          -- In v2 prompt() submits immediately. Ask keeps the selection
          -- editable until you add an instruction and confirm submission.
          require("opencode").ask("@this ")
        end,
        mode = "x",
        desc = "Ask OpenCode with selected code",
      },

      {
        "<leader>oa",
        function()
          require("opencode").ask("@this: ")
        end,
        mode = { "n", "x" },
        desc = "Ask OpenCode",
      },

      {
        "<leader>os",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "OpenCode actions",
      },
      {
        "<leader>oe",
        function()
          require("opencode").prompt("Explain @this and its context")
        end,
        mode = { "n", "x" },
        desc = "Explain code with OpenCode",
      },
    },

    config = function()
      vim.g.opencode_opts = {
        server = {
          -- Discover the shared service and its credentials automatically.
          -- Start our TUI only when no healthy service is available.
          start = ensure_opencode,
        },
      }
    end,
  },
}
