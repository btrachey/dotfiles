-- treesitter text objects; https://github.com/nvim-treesitter/nvim-treesitter-textobjects
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  opts = {
    set_jumps = true,
  },
  keys = {
    {
      "aa",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@parameter.outer",
          "textobjects"
        )
      end,
      mode = { "x", "o" },
      desc = "parameter",
    },
    {
      "ia",
      function()
        require("nvim-treesitter-textobjects.select").select_textobject(
          "@parameter.inner",
          "textobjects"
        )
      end,
      mode = { "x", "o" },
      desc = "parameter",
    },
    {
      "[c",
      function()
        require("nvim-treesitter-textobjects.move").goto_previous_start(
          "@comment.outer",
          "textobjects"
        )
      end,
      mode = { "n", "x", "o" },
    },
    {
      "]c",
      function()
        require("nvim-treesitter-textobjects.move").goto_next_start(
          "@comment.outer",
          "textobjects"
        )
      end,
      mode = { "n", "x", "o" },
    },
  },
}
