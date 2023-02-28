local F = require("btrachey.functions")

local function setup()
  -- ctrl + movement key moves between vim splits or tmux panes
  local function tmux_move(direction)
    return function()
      local lookup = {
        p = "l", -- "previous" if I ever decide to implement it
        h = "L",
        j = "D",
        k = "U",
        l = "R",
      }
      local wnr = vim.api.nvim_win_get_number(0)
      vim.cmd('wincmd ' .. direction)
      if vim.api.nvim_win_get_number(0) == wnr then
        vim.fn.system([[tmux select-pane -]] .. lookup[direction])
      end
    end
  end

  -- movement
  F.map({"n", "i"}, "<C-h>", tmux_move('h'), { desc = "Move left one window, whether it is a vim split or a tmux pane." })
  F.map({"n", "i"}, "<C-j>", tmux_move('j'), { desc = "Move down one window, whether it is a vim split or a tmux pane." })
  F.map({"n", "i"}, "<C-k>", tmux_move('k'), { desc = "Move up one window, whether it is a vim split or a tmux pane." })
  F.map({"n", "i"}, "<C-l>", tmux_move('l'), { desc = "Move right one window, whether it is a vim split or a tmux pane." })
end

return {
  setup = setup
}
