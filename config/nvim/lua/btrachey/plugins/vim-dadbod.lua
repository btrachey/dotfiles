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
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_use_nvim_notify = true
      vim.g.db_ui_execute_on_save = false
    end,
    config = function()
      local dbs = function()
        local base_conns = {}
        for _, env in ipairs({ "local", "dev", "preprod" }) do
          local conn_string = vim.fn.system({ "mysql_argos", env, "--uri" })
          vim.notify(conn_string)
          if vim.v.shell_error ~= 0 then
            vim.notify(
              "Not logged in to Vault, cannot create DB connection for env "
                .. env,
              "warn"
            )
          else
            vim.list_extend(
              base_conns,
              { { name = "argos-" .. env, url = conn_string } }
            )
          end
        end
        return base_conns
      end
      vim.g.dbs = dbs()
    end,
  },
}
