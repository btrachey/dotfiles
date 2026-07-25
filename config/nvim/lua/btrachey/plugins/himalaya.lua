return {
  -- "pimalaya/himalaya-vim",
  "xav-ie/himalaya-nvim",
  -- init = function()
  --   vim.g.himalaya_account_picker = "telescope"
  -- end,
  dependencies = {
    {
      "xav-ie/image.nvim",
      build = false,
      opts = {
        processor = "magick_cli",
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      version = "*",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- optional but recommended
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
    },
  },
}
