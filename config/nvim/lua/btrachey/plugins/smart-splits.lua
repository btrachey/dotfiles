-- integration between nvim and wezterm multiplexing
-- https://github.com/mrjones2014/smart-splits.nvim

return {
  "mrjones2014/smart-splits.nvim",
  keys = {
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      mode = { "n", "v" },
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      mode = { "n", "v" },
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      mode = { "n", "v" },
    },
    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      mode = { "n", "v" },
    },
    {
      "<C-\\>",
      function()
        require("smart-splits").move_cursor_previous()
      end,
      mode = { "n", "v" },
    },
  },
}
