-- menus that show key bindings after pressing a prefix
-- https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>h", group = "git ops" },
      { "<leader>k", group = "cellular automaton" },
      { "<leader>m", group = "nvim metals" },
      { "<leader>a", group = "LSP diagnostics" },
      { "<leader>d", group = "DAP" },
    },
    plugins = {
      marks = false,
      presets = {
        windows = false,
      },
    },
    icons = {
      mappings = false,
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
