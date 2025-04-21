-- Telescope plugin https://github.com/nvim-telescope/telescope.nvim
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  cmd = "Telescope",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = function()
    return {
      defaults = {
        path_display = { "smart" },
        layout_strategy = "vertical",
        mappings = {
          i = {
            ["<esc>"] = require("telescope.actions").close,
          },
        },
      },
    }
  end,
  keys = {
    {
      "<leader>f",
      function()
        require("telescope.builtin").find_files()
      end,
      -- function() require("telescope.builtin").find_files(require("telescope.themes").get_ivy()) end,
      desc = "Telescope find files",
    },
    {
      "<leader>hg",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Telescope git status",
    },
    {
      "<leader>g",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Telescope live grep",
    },
    {
      "<leader>gg",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Telescope grep word under cursor",
    },
    {
      "<leader>b",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Telescope list buffers",
    },
    {
      "<leader>cc",
      function()
        require("telescope.builtin").colorscheme({ enable_preview = true })
      end,
      desc = "Telescope colorschemes",
    },
    {
      "<leader>l",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Telescope re-open last picker",
    },
  },
}
