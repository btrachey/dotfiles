return {
  {
    "stevearc/conform.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        javascript = { "prettier" },
        vue = { "prettier" },
        lua = { "stylua" },
        go = { "gofmt" },
        -- xml = { "prettier" },
        sql = { "sql" },
        madlib = { "madlib" },
        mysql = { "mysql" },
        postgres = { "postgres" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
      formatters = {
        sql = {
          command = "sqlfluff",
          args = { "format", "--dialect=ansi", "-" },
          cwd = function()
            return vim.fn.getcwd(0)
          end,
        },
        madlib = {
          command = "madlib",
          args = { "format" },
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
    init = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          vim.lsp.buf.format()
          require("conform").format({ bufnr = args.buf })
          if vim.fn.exists(":MetalsOrganizeImports") > 0 then
            vim.cmd("MetalsOrganizeImports")
          end
        end,
      })
    end,
  },
}
