-- menus that show key bindings after pressing a prefix
-- https://github.com/folke/which-key.nvim
return {
  "folke/which-key.nvim",
  opts = {
    preset = "helix",
    spec = {
      { "<leader>a", group = "LSP diagnostics" },
      { "<leader>c", group = "Code lens/action" },
      { "<leader>d", group = "DAP" },
      { "<leader>h", group = "Git ops" },
      { "<leader>m", group = "Metals" },
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
