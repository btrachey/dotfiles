return {
  {
    "stevearc/conform.nvim",
    opts = {
      log_level = vim.log.levels.DEBUG,
      formatters_by_ft = {
        bash = { "shfmt" },
        javascript = { "prettier" },
        vue = { "prettier" },
        lua = { "stylua" },
        go = { "gofmt" },
        http = { "kulala" },
        markdown = { "prettier" },
        -- xml = { "prettier" },
        sh = { "shfmt" },
        sql = { "sql" },
        tex = { "texfmt" },
        madlib = { "madlib" },
        mysql = { "mysql" },
        postgres = { "postgres" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        zsh = { "shfmt" },
      },
      formatters = {
        texfmt = {
          command = "tex-fmt",
          args = { "$FILENAME" },
          stdin = false,
        },
        kulala = {
          command = "kulala-fmt",
          args = { "format", "$FILENAME" },
          stdin = false,
        },
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
  },
}
