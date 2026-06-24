local F = require("btrachey.functions")

return {
  "scalameta/nvim-metals",
  -- dir = "/Users/brian.tracey/Repos/nvim-metals/",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
    -- "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>mt",
      function()
        require("metals.tvp").toggle_tree_view()
      end,
      desc = "Tree View",
    },
    {
      "<leader>mr",
      function()
        require("metals.tvp").reveal_in_tree()
      end,
      desc = "Reveal in Tree View",
    },
    {
      "<leader>mw",
      function()
        require("metals").hover_worksheet()
      end,
      desc = "Hover in Worksheet",
    },
    {
      "<leader>mm",
      function()
        require("metals").commands()
      end,
      desc = "Command Picker",
    },
    {
      "<leader>mc",
      function()
        require("metals").compile_cascade()
      end,
      desc = "Compile Cascade",
    },
    {
      "gt",
      function()
        F.find_scala_test_file()
      end,
      desc = "Go to Corresponding Scala Test File",
    },
  },
  init = function()
    local nvim_metals_group = F.augroup("nvim-metals")
    local config_table = {
      init_options = {
        statusBarProvider = "off",
        globSyntax = "vscode",
      },
      settings = {
        -- serverVersion = "1.5.1",
        -- serverVersion = "1.5.2-SNAPSHOT",
        -- startMcpServer = true,
        showImplicitArguments = true,
        showImplicitConversionsAndClasses = true,
        showInferredType = true,
        defaultBspToBuildTool = true,
        automaticImportBuild = "all",
      },
      tvp = {
        icons = { enabled = true },
      },
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      on_attach = function()
        require("metals").setup_dap()
      end,
    }
    local metals_config = vim.tbl_deep_extend(
      "error",
      require("metals").bare_config(),
      config_table
    )

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
      pattern = { "*.worksheet.sc" },
      callback = function()
        vim.lsp.inlay_hint.enable(true)
      end,
      group = nvim_metals_group,
    })
  end,
}
