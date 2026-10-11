return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        always_show_bufferline = true,
        diagnostics = false,
        separator_style = "slant",
        show_buffer_close_icons = false,
        show_close_icon = false,
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "snacks_layout_box",
            text = "Explorer",
            text_align = "center",
          },
        },
      },
    },
  },
}
