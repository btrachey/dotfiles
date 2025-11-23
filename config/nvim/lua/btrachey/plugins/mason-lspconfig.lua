return {
  "williamboman/mason-lspconfig.nvim",
  lazy = false,
  config = function()
    require("mason-lspconfig").setup({
      automatic_installation = true,
      automatic_enable = true,
      ensure_installed = {
        "basedpyright",
        "bashls",
        "cssls",
        "dockerls",
        "gopls",
        "jsonls",
        "lua_ls",
        "marksman",
        "ruff",
        "superhtml",
        "taplo",
        "ts_ls",
        "yamlls",
      },
    })
    -- require("mason-lspconfig").setup_handlers({
    --   function(server_name)
    --     require("lspconfig")[server_name].setup({
    --       on_attach = require("btrachey.lsp").attach_func,
    --       capabilities = require("blink.cmp").get_lsp_capabilities(),
    --     })
    --   end,
    -- ["bashls"] = function()
    --   require("lspconfig").bashls.setup({
    --     on_attach = require("btrachey.lsp").attach_func,
    --     capabilities = require("blink.cmp").get_lsp_capabilities(),
    --     filetypes = { "bash", "sh", "zsh" },
    --   })
    -- end,
    -- ["basedpyright"] = function()
    --   require("lspconfig").basedpyright.setup({
    --     on_attach = require("btrachey.lsp").attach_func,
    --     capabilities = require("blink.cmp").get_lsp_capabilities(),
    --     on_new_config = function(new_config, dir)
    --       if
    --         require("btrachey.functions").dir_has_file(dir, "poetry.lock")
    --       then
    --         vim.notify_once("Using poetry venv for basedpyright.")
    --         new_config.settings.python.pythonPath = dir .. "/.venv/bin/python"
    --       else
    --         vim.notify_once("Using pyenv venv for basedpyright.")
    --       end
    --     end,
    --   })
    -- end,
    --   })
  end,
}
