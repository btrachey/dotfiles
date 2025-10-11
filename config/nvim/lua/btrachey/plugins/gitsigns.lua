return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  opts = {
    current_line_blame_opts = {
      virt_text_pos = "right_align",
    },
  },
  keys = {
    {
      "]g",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "]g", bang = true })
        else
          require("gitsigns").nav_hunk("next", { preview = true })
        end
      end,
      desc = "Next git hunk (if one exists)",
    },
    {
      "[g",
      function()
        if vim.wo.diff then
          vim.cmd.normal({ "[g", bang = true })
        else
          require("gitsigns").nav_hunk("prev", { preview = true })
        end
      end,
      desc = "Previous git hunk (if one exists)",
    },
    {
      "<leader>hs",
      function()
        require("gitsigns").stage_hunk()
      end,
      desc = "Git un/stage hunk",
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk()
      end,
      desc = "Git reset hunk",
    },
    {
      "<leader>hs",
      function()
        require("gitsigns").stage_hunk(vim.fn.line("."), vim.fn.line("v"))
      end,
      desc = "Git stage hunk (visual)",
      mode = { "v" },
    },
    {
      "<leader>hr",
      function()
        require("gitsigns").reset_hunk(vim.fn.line("."), vim.fn.line("v"))
      end,
      desc = "Git reset hunk (visual)",
      mode = { "v" },
    },
    {
      "<leader>hp",
      function()
        require("gitsigns").preview_hunk()
      end,
      desc = "Git preview hunk",
    },
    {
      "<leader>hS",
      function()
        require("gitsigns").stage_buffer()
      end,
      desc = "Git stage buffer",
    },
    {
      "<leader>hR",
      function()
        require("gitsigns").reset_buffer()
      end,
      desc = "Git reset buffer",
    },
    {
      "<leader>hb",
      function()
        require("gitsigns").blame_line({ full = true })
      end,
      desc = "Git blame line",
    },
    {
      "<leader>hB",
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      desc = "Git toggle current line blame",
    },
    {
      "<leader>hd",
      function()
        require("gitsigns").diffthis()
      end,
      desc = "gitsigns `diffthis`",
    },
    {
      "<leader>hD",
      function()
        require("gitsigns").diffthis("~")
      end,
      desc = "gitsigns `diffthis('~')`",
    },
    {
      "ih",
      ":<C-U>Gitsigns select_hunk<CR>",
      desc = "Git hunk as text object",
      mode = { "o", "x" },
    },
  },
}
