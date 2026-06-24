return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      local Terminal = require("toggleterm.terminal").Terminal
      _G.lazyjira = Terminal:new({
        cmd = "lazyjira",
        direction = "float",
        float_opts = {
          border = "double",
        },
        hidden = true,
      })
    end,

    keys = {
      {
        "<leader>j",
        function()
          _G.lazyjira:toggle()
        end,
        desc = "Toggle Jira",
      },
    },
  },
}
