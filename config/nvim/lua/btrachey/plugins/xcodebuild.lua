return {
  "wojciech-kulik/xcodebuild.nvim",
  dependencies = {
    -- Uncomment a picker that you want to use, snacks.nvim might be additionally
    -- useful to show previews and failing snapshots.

    -- You must select at least one:
    -- "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    "folke/snacks.nvim", -- (optional) to show previews

    "MunifTanjim/nui.nvim",
    "stevearc/oil.nvim", -- (optional) to manage project files
  },
  config = function()
    require("xcodebuild.integrations.dap").setup()

    local dap, dapui = require("dap"), require("dap-view")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    require("xcodebuild").setup({
      show_build_progress_bar = true,
      restore_on_start = false,
      auto_save = true,
      logs = {
        auto_open_on_failed_tests = true,
        auto_open_on_failed_build = true,
        auto_open_on_start = true,
        show_warnings = true,
        show_build_status = true,
      },
    })
    vim.keymap.set(
      "n",
      "<leader>X",
      "<cmd>XcodebuildPicker<cr>",
      { desc = "Show Xcodebuild Actions" }
    )
    vim.keymap.set(
      "n",
      "<leader>xf",
      "<cmd>XcodebuildProjectManager<cr>",
      { desc = "Show Project Manager Actions" }
    )

    vim.keymap.set(
      "n",
      "<leader>xb",
      "<cmd>XcodebuildBuild<cr>",
      { desc = "Build Project" }
    )
    vim.keymap.set(
      "n",
      "<leader>xB",
      "<cmd>XcodebuildBuildForTesting<cr>",
      { desc = "Build For Testing" }
    )
    vim.keymap.set(
      "n",
      "<leader>xr",
      "<cmd>XcodebuildBuildRun<cr>",
      { desc = "Build & Run Project" }
    )

    vim.keymap.set(
      "n",
      "<leader>xt",
      "<cmd>XcodebuildTest<cr>",
      { desc = "Run Tests" }
    )
    vim.keymap.set(
      "v",
      "<leader>xt",
      "<cmd>XcodebuildTestSelected<cr>",
      { desc = "Run Selected Tests" }
    )
    vim.keymap.set(
      "n",
      "<leader>xT",
      "<cmd>XcodebuildTestClass<cr>",
      { desc = "Run Current Test Class" }
    )
    vim.keymap.set(
      "n",
      "<leader>x.",
      "<cmd>XcodebuildTestRepeat<cr>",
      { desc = "Repeat Last Test Run" }
    )

    vim.keymap.set(
      "n",
      "<leader>xl",
      "<cmd>XcodebuildToggleLogs<cr>",
      { desc = "Toggle Xcodebuild Logs" }
    )
    vim.keymap.set(
      "n",
      "<leader>xc",
      "<cmd>XcodebuildToggleCodeCoverage<cr>",
      { desc = "Toggle Code Coverage" }
    )
    vim.keymap.set(
      "n",
      "<leader>xC",
      "<cmd>XcodebuildShowCodeCoverageReport<cr>",
      { desc = "Show Code Coverage Report" }
    )
    vim.keymap.set(
      "n",
      "<leader>xe",
      "<cmd>XcodebuildTestExplorerToggle<cr>",
      { desc = "Toggle Test Explorer" }
    )
    vim.keymap.set(
      "n",
      "<leader>xs",
      "<cmd>XcodebuildFailingSnapshots<cr>",
      { desc = "Show Failing Snapshots" }
    )

    vim.keymap.set(
      "n",
      "<leader>xp",
      "<cmd>XcodebuildPreviewGenerateAndShow<cr>",
      { desc = "Generate Preview" }
    )
    vim.keymap.set(
      "n",
      "<leader>x<cr>",
      "<cmd>XcodebuildPreviewToggle<cr>",
      { desc = "Toggle Preview" }
    )

    vim.keymap.set(
      "n",
      "<leader>xd",
      "<cmd>XcodebuildSelectDevice<cr>",
      { desc = "Select Device" }
    )
    vim.keymap.set(
      "n",
      "<leader>xq",
      "<cmd>Telescope quickfix<cr>",
      { desc = "Show QuickFix List" }
    )

    vim.keymap.set(
      "n",
      "<leader>xx",
      "<cmd>XcodebuildQuickfixLine<cr>",
      { desc = "Quickfix Line" }
    )
    vim.keymap.set(
      "n",
      "<leader>xa",
      "<cmd>XcodebuildCodeActions<cr>",
      { desc = "Show Code Actions" }
    )
    -- put some options here or leave it empty to use default settings
  end,
}
