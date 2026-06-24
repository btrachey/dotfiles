return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  -- config = true,
  opts = {
    image = {},
    picker = {
      -- layout = {
      --   preset = "ivy",
      -- },
      previewers = {
        diff = {
          builtin = false,
          cmd = { "delta" },
        },
      },
      win = {
        input = {
          keys = {
            ["<Esc>"] = { "close", mode = { "n", "i" } },
          },
        },
      },
    },
    explorer = {},
    notifier = {},
  },
  keys = {
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>hf",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Files Diff",
    },
    {
      "<leader>hh",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>f",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>b",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>g",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>n",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification History",
    },
    {
      "<leader>l",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume Last Picker",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "LSP Definitions",
    },
    {
      "gi",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "LSP Implementations",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "LSP References",
    },
    {
      "gws",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP Workspace Symbols",
    },
    {
      "<leader>a",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>aa",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "All Diagnostics",
    },
    {
      "<leader>ae",
      function()
        Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.ERROR })
      end,
      desc = "All Error Diagnostics",
    },
    {
      "<leader>aw",
      function()
        Snacks.picker.diagnostics({ severity = vim.diagnostic.severity.WARN })
      end,
      desc = "All Warning Diagnostics",
    },
  },
}
