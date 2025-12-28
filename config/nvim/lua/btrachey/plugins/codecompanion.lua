return {
  "olimorris/codecompanion.nvim",
  config = true,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    display = {
      action_palette = {
        provider = "telescope",
      },
    },
    strategies = {
      chat = {
        adapter = "gemini_cli",
      },
      inline = {
        adapter = "gemini_cli",
      },
    },
  },
  keys = {
    {
      "<leader>ll",
      "<cmd>CodeCompanionActions<cr>",
      desc = "CodeCompanion palette",
    },
  },
}
