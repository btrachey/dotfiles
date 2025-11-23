return {
  -- https://github.com/stevearc/conform.nvim
  -- custom formatters
  {
    "stevearc/conform.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
      format_on_save = {
        -- timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        vue = { "prettier" },
        lua = { "stylua" },
        go = { "gofmt" },
        -- xml = { "prettier" },
        sql = { "sql" },
        mysql = { "mysql" },
        postgres = { "postgres" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        ["*"] = { "injected" },
      },
      formatters = {
        sql = {
          command = "sqlfluff",
          args = { "format", "--dialect=ansi", "-" },
          cwd = function()
            return vim.fn.getcwd(0)
          end,
        },
        mysql = {
          command = "sqlfluff",
          args = { "format", "--dialect=mysql", "-" },
          cwd = function()
            return vim.fn.getcwd(0)
          end,
        },
        postgres = {
          command = "sqlfluff",
          args = { "format", "--dialect=postgres", "-" },
          cwd = function()
            return vim.fn.getcwd(0)
          end,
        },
        stylua = {
          prepend_args = function()
            local cur_width = vim.o.textwidth
            return {
              "--column-width",
              cur_width,
              "--indent-type",
              "Spaces",
              "--indent-width",
              "2",
            }
          end,
        },
      },
    },
  },
}
