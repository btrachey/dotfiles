return {
  -- db interaction in vim https://github.com/kristijanhusak/vim-dadbod-ui
  { "tpope/vim-dadbod", cmd = "DB" },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = {
      "tpope/vim-dadbod",
    },
    ft = { "sql", "mysql", "plsql" },
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod" },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    keys = { { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" } },
    init = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_auto_execute_table_helpers = true
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_execute_on_save = false
    end,
    config = function()
      function conn_string(env)
        local conn = vim.fn.system({ "tg", "mysql", "--" .. env, "--uri" })
        if vim.v.shell_error ~= 0 then
          vim.notify(
            "Not logged in to Vault, cannot create DB connection for env "
            .. env
          )
        else
          return conn
        end
      end

      vim.g.dbs = {
        {
          name = "argos-local",
          url = conn_string("local"),
        },
        {
          name = "argos-sbx",
          url = conn_string("sbx"),
        },
        {
          name = "argos-dev",
          url = conn_string("dev"),
        },
        {
          name = "argos-test",
          url = conn_string("test"),
        },
        {
          name = "argos-prod",
          url = conn_string("prod"),
        },
      }
    end,
  },
}
