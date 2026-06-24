return {
  "nvim-mini/mini.nvim",
  version = "*",
  config = function()
    require("mini.pairs").setup()
    require("mini.indentscope").setup()
    require("mini.icons").setup()
  end,
}
