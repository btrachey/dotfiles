return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  config = function()
    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        "basedpyright",
        "bashls",
        "cssls",
        "dockerls",
        "lua_ls",
        "marksman",
        "ruff",
        "sqlls",
        "superhtml",
        "taplo",
        "ts_ls",
        "yamlls",
      },
    })
    require("mason-lspconfig").setup_handlers({
      function(server_name)
        require("lspconfig")[server_name].setup({
          on_attach = require("btrachey.lsp").attach_func,
          capabilities = require("blink.cmp").get_lsp_capabilities()
        })
      end,
      ["bashls"] = function()
        require("lspconfig").bashls.setup({
          on_attach = require("btrachey.lsp").attach_func,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          filetypes = { "bash", "sh", "zsh" }
        })
      end,
      ["basedpyright"] = function()
        require("lspconfig").basedpyright.setup({
          on_attach = require("btrachey.lsp").attach_func,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          on_new_config = function(new_config, dir)
            if require("btrachey.lsp").dir_has_file(dir, "poetry.lock") then
              vim.notify_once("Using manually configured python from poetry venv for basedpyright.")
              new_config.settings.python.pythonPath = dir .. "/.venv/bin/python"
            else
              vim.notify_once("Using the pyenv virtualenv for basedpyright.")
            end
          end
        })
      end,
      ["lua_ls"] = function()
        local runtime_path = function()
          local path = vim.split(package.path, ";")
          table.insert(path, "lua/?.lua")
          table.insert(path, "lua/?/init.lua")
          return path
        end
        require("lspconfig").lua_ls.setup({
          on_attach = require("btrachey.lsp").attach_func,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          settings = {
            Lua = {
              format = {
                enable = true,
                defaultConfig = {
                  max_line_length = 80,
                  -- max_line_length = vim.o.textwidth,
                  table_separator_style = "comma",
                  trailing_table_separator = "always"
                }
              },
              -- runtime = {
              --   version = "LuaJIT",
              --   path = runtime_path()
              -- },
              -- diagnostics = {
              --   globals = { "vim", "require" }
              -- },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false }
            }
          }
        })
      end
    })
  end
}
