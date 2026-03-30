return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "igorlfs/nvim-dap-view",
      -- let the plugin lazy load itself
      lazy = false,
      ---@module 'dap-view'
      ---@type dapview.Config
      opts = {},
      keys = {
        {
          "<leader>d",
          function()
            require("dap-view").toggle()
          end,
          desc = "Toggle dap-view plugin.",
        },
      },
    },
  },
  init = function()
    local dap = require("dap")

    dap.configurations.scala = {
      {
        type = "scala",
        request = "attach",
        name = "Debug (Attach) - Remote",
        hostName = "127.0.0.1",
        port = 9999,
        buildTarget = "root",
      },
      {
        type = "scala",
        request = "launch",
        name = "Run Or Test Current File",
        metals = {
          runType = "runOrTestFile",
        },
      },
      -- https://www.chris-kipp.io/blog/the-debug-adapter-protocol-and-scala
      {
        type = "scala",
        request = "launch",
        name = "Run Or Test Current File With Args",
        metals = {
          runType = "runOrTestFile",
          args = function()
            local args = {}
            local input = vim.fn.input("Arguments: ")
            for w in input:gmatch("%S+") do
              table.insert(args, w)
            end
            return args
          end,
        },
      },
      {
        type = "scala",
        request = "launch",
        name = "Test Entire Build Target",
        metals = {
          runType = "testTarget",
        },
      },
    }
    -- auto open/close dapui with dap
    dap.listeners.after.event_initialized["nvim-metals"] = function()
      require("dap-view").toggle()
      -- dap.repl.open()
    end
    vim.fn.sign_define(
      "DapBreakpoint",
      { text = "", texthl = "", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapBreakpointCondition",
      { text = "", texthl = "", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapLogPoint",
      { text = "󰇙", texthl = "", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapStopped",
      { text = "→", texthl = "", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
      "DapBreakpointRejected",
      { text = "", texthl = "", linehl = "", numhl = "" }
    )
  end,
  keys = function()
    return {
      {
        "<leader>dc",
        require("dap").continue,
        desc = "DAP continue execution",
      },
      {
        "<leader>dr",
        require("dap").repl.toggle,
        desc = "DAP toggle the REPL",
      },
      {
        "<leader>dt",
        require("dap").toggle_breakpoint,
        desc = "DAP toggle breakpoint",
      },
      {
        "<leader>dd",
        require("dap").continue,
        desc = "DAP continue/start",
      },
      {
        "<leader>dso",
        require("dap").step_over,
        desc = "DAP step over",
      },
      {
        "<leader>dsi",
        require("dap").step_into,
        desc = "DAP step into",
      },
      {
        "<leader>dl",
        require("dap").run_last,
        desc = "DAP re-run the last executed command",
      },
    }
  end,
}
