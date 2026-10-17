local group = vim.api.nvim_create_augroup(
  "personal_config",
  { clear = true }
)

-- Save edited files when leaving Insert mode, switching buffers, or
-- changing focus. Skip unnamed, read-only, and non-file buffers.
local function autosave(args)
  local buf = args.buf or vim.api.nvim_get_current_buf()

  if not vim.api.nvim_buf_is_valid(buf)
    or not vim.bo[buf].modified
    or vim.bo[buf].readonly
    or vim.bo[buf].buftype ~= ""
    or vim.api.nvim_buf_get_name(buf) == ""
  then
    return
  end

  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent update")
  end)
end

vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "FocusLost" }, {
  group = group,
  callback = autosave,
})

-- Return to the last position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,

  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)

    if mark[1] > 0 and mark[1] <= line_count then
      pcall(
        vim.api.nvim_win_set_cursor,
        0,
        { mark[1], mark[2] }
      )
    end
  end,
})
