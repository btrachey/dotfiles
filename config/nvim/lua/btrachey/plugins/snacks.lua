return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  -- config = true,
  opts = {
    -- gh = {
    --
    -- }
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
    dashboard = {
      sections = {
        {
          align = "right",
          text = {
            [[
░   ░░░  ░░        ░░░      ░░
▒    ▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒
▓  ▓  ▓  ▓▓      ▓▓▓▓  ▓▓▓▓  ▓
█  ██    ██  ████████  ████  █
█  ███   ██        ███      ██
]],
            hl = "header",
          },
        },
        {
          pane = 2,
          text = {
            [[
░  ░░░░  ░░        ░░  ░░░░  ░
▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒
▓▓  ▓▓  ▓▓▓▓▓▓  ▓▓▓▓▓        ▓
███    ███████  █████  █  █  █
████  █████        ██  ████  █
]],
            hl = "header",
          },
        },
        {
          section = "keys",
          gap = 1,
          padding = 1,
        },
        { section = "startup" },
        {
          pane = 2,
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1,
        },
        {
          pane = 2,
          icon = "",
          title = "Open PRs",
          cmd = "gh pr list -L 3",
          key = "P",
          ttl = 5 * 60,
          enabled = require("snacks").git.get_root() ~= nil,
          action = function()
            vim.fn.jobstart("gh pr list --web", { detach = true })
          end,
          height = 7,
          padding = 1,
          section = "terminal",
        },
        {
          pane = 2,
          section = "terminal",
          cmd = "wttr",
          ttl = 30 * 60,
          padding = 1,
        },
      },
    },
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
      Snacks.picker.git_diff,
      desc = "Git Files Diff",
    },
    {
      "<leader>hh",
      Snacks.picker.git_branches,
      desc = "Git Branches",
    },
    {
      "<leader>f",
      Snacks.picker.smart,
      desc = "Smart Find Files",
    },
    {
      "<leader>b",
      Snacks.picker.buffers,
      desc = "Buffers",
    },
    {
      "<leader>g",
      Snacks.picker.grep,
      desc = "Grep",
    },
    {
      "<leader>:",
      Snacks.picker.command_history,
      desc = "Command History",
    },
    {
      "<leader>n",
      Snacks.picker.notifications,
      desc = "Notification History",
    },
    {
      "<leader>l",
      Snacks.picker.resume,
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
      Snacks.picker.lsp_definitions,
      desc = "LSP Definitions",
    },
    {
      "gi",
      Snacks.picker.lsp_implementations,
      desc = "LSP Implementations",
    },
    {
      "gr",
      Snacks.picker.lsp_references,
      desc = "LSP References",
    },
    {
      "gws",
      Snacks.picker.lsp_workspace_symbols,
      desc = "LSP Workspace Symbols",
    },
    {
      "<leader>a",
      Snacks.picker.diagnostics_buffer,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>aa",
      Snacks.picker.diagnostics,
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
