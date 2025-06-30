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
        local baseConns = {
          {
            name = "argos-local",
            url = "mysql://127.0.0.1:3306/?user=argos&password=argos",
          },
        }
        local function makeConn(env)
          if env ~= "dev" then
            if env ~= "preprod" then
              vim.notify(
                "Can only create connections for dev/preprod('test'); given '"
                  .. env
                  .. "'"
              )
              return
            end
          end
          local connName = "argos-" .. env
          local credsReq = vim.fn.system({
            "vault",
            "read",
            "-address=https://vault.preprod.topgolf.io",
            "-format=json",
            "argos-" .. env .. "-mysql/creds/read",
          })
          if vim.v.shell_error ~= 0 then
            vim.notify(
              "Not logged in to Vault, cannot create DB connection `"
                .. connName
                .. "`\n"
                .. "try `vault login -address='https://vault.preprod.topgolf.io' -method=ldap username=brian.tracey`",
              "warn"
            )
            return
          else
            local creds = vim.json.decode(credsReq)
            local connString = "mysql://"
              .. creds.data.username
              .. ":"
              .. creds.data.password
              .. "@argos-mysql."
              .. env
              .. ".tgm.topgolf.io:3306/argos"

            vim.list_extend(
              baseConns,
              { { name = connName, url = connString } }
            )
            return
          end
        end
        for _, env in ipairs({ "dev", "preprod" }) do
          makeConn(env)
        end
        return baseConns
      end
      vim.g.dbs = dbs()
    end,
  },
}
