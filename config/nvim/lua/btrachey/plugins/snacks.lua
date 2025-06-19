return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  -- config = true,
  opts = {
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
      "<leader>aa",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "All Diagnostics",
    },
    -- {
    --   "<leader>mm",
    --   function()
    --     require("snacks").picker({
    --       title = "Metals Commands",
    --       layout = {
    --         preset = "select",
    --       },
    --       items = require("metals.commands").commands_table,
    --       confirm = function(picker, item)
    --         picker:close()
    --         vim.notify("picked" .. item.id)
    --         require("metals")[item.id]()
    --       end,
    --     })
    --   end,
    --   desc = "All Diagnostics",
    -- },
  },
}
