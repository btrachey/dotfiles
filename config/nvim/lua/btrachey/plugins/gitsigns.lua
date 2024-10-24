return {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  opts = {
    current_line_blame_opts = {
      virt_text_pos = 'right_align',
    },
  },
  keys = function()
    local gs = require("gitsigns")
    return {
      {
        "]g",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "]g", bang = true })
          else
            gs.nav_hunk("next", { preview = true })
          end
        end,
        desc = "Next git hunk (if one exists)"
      },
      {
        "[g",
        function()
          if vim.wo.diff then
            vim.cmd.normal({ "[g", bang = true })
          else
            gs.nav_hunk("prev", { preview = true })
          end
        end,
        desc = "Previous git hunk (if one exists)"
      },
      { "<leader>hs", gs.stage_hunk, desc = "Git stage hunk" },
      { "<leader>hr", gs.reset_hunk, desc = "Git reset hunk" },
      {
        "<leader>hs",
        function()
          gs.stage_hunk(vim.fn.line("."), vim.fn.line("v"))
        end,
        desc = "Git stage hunk (visual)",
        mode = { "v" }
      },
      {
        "<leader>hr",
        function()
          gs.reset_hunk(vim.fn.line("."), vim.fn.line("v"))
        end,
        desc = "Git reset hunk (visual)",
        mode = { "v" }
      },
      { "<leader>hu", gs.undo_stage_hunk, desc = "Git undo stage hunk" },
      { "<leader>hp", gs.preview_hunk,    desc = "Git preview hunk" },
      { "<leader>hS", gs.stage_buffer,    desc = "Git stage buffer" },
      { "<leader>hR", gs.reset_buffer,    desc = "Git reset buffer" },
      {
        "<leader>hb",
        function()
          gs.blame_line({ full = true })
        end,
        desc = "Git blame line"
      },
      { "<leader>hB", gs.toggle_current_line_blame, desc = "Git toggle current line blame" },
      { "<leader>hd", gs.diffthis,                  desc = "gitsigns `diffthis`" },
      {
        "<leader>hD",
        function()
          gs.diffthis("~")
        end,
        desc = "gitsigns `diffthis('~')`"
      },
      { "ih", ":<C-U>Gitsigns select_hunk<CR>", desc = "Git hunk as text object", mode = { "o", "x" } }
    }
  end
}
