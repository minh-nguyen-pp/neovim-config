local group = vim.api.nvim_create_augroup(
  "personal_config",
  { clear = true }
)

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
