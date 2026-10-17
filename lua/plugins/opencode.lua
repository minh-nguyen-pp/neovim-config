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

-- Paste references into this Neovim's TUI draft without submitting a prompt.
-- Keep editor focus so selections from multiple files can be added in turn.
local function append_selection()
  local terminal = Snacks.terminal.get(cmd, { cwd = cwd, count = 1, create = false })
  local job = terminal and vim.b[terminal.buf].terminal_job_id
  if not job or vim.fn.jobwait({ job }, 0)[1] ~= -1 then
    vim.notify("Open the OpenCode TUI with ,ot first, then add selections with ,oy.", vim.log.levels.WARN)
    return
  end

  local mode = vim.fn.mode()
  if not mode:match("[vV\22]") then
    return
  end

  local anchor = vim.fn.getpos("v")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local from = { anchor[2], anchor[3] }
  local to = { cursor[1], cursor[2] + 1 }
  if from[1] > to[1] or (from[1] == to[1] and from[2] > to[2]) then
    from, to = to, from
  end
  if mode == "V" then
    from, to = { from[1] }, { to[1] }
  elseif mode == "\22" then
    from[2], to[2] = math.min(from[2], to[2]), math.max(from[2], to[2])
  end

  -- Absolute references also work when the editor's cwd has changed.
  local text = require("opencode").format({ buf = vim.api.nvim_get_current_buf(), from = from, to = to })
  if not text or text == "" then
    vim.notify("Save the buffer to a file before adding an OpenCode reference.", vim.log.levels.WARN)
    return
  end

  -- Bracketed paste inserts text literally, without sending Enter to the TUI.
  vim.api.nvim_chan_send(job, "\27[200~" .. text .. " \27[201~")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  vim.notify("Added selection to OpenCode draft", vim.log.levels.INFO)
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
        append_selection,
        mode = "x",
        desc = "Add selected code to OpenCode draft",
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
