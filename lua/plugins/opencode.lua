-- Allocate a different port for each Neovim process.
-- macOS chooses an available local TCP port.
local function allocate_port()
  local socket = assert(vim.uv.new_tcp())

  local ok, err = socket:bind("127.0.0.1", 0)
  if not ok then
    socket:close()
    error(err)
  end

  local address = assert(socket:getsockname())
  local port = address.port

  socket:close()
  return port
end

-- The directory where this Neovim instance started.
-- Launch Neovim from your worktree root.
local cwd = vim.fn.getcwd()

local port = allocate_port()
local url = "http://127.0.0.1:" .. port
local cmd = "opencode --hostname 127.0.0.1 --port " .. port

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

    -- Keep OpenCode v1 compatibility.
    version = "1.0.1",

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
          -- Append ONLY the selected code reference.
          -- Do not submit the prompt.
          require("opencode").prompt("@this ")
        end,
        mode = "x",
        desc = "Send selected code to OpenCode",
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
          -- Explicitly target this Neovim's own server.
          url = url,

          -- Auto-start it only when connection fails.
          start = ensure_opencode,
        },
      }
    end,
  },
}
