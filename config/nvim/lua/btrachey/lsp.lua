local F = require("btrachey.functions")
-- local telescope_builtin = require("telescope.builtin")
-- local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })

-- local attach_func = function(client, bufnr)
-- LSP mappings
-- F.map(
--   "n",
--   "gd",
--   telescope_builtin.lsp_definitions,
--   { desc = "go to definition" }
-- )
-- F.map(
--   "n",
--   "gi",
--   telescope_builtin.lsp_implementations,
--   { desc = "go to implementation" }
-- )
-- F.map(
--   "n",
--   "gr",
--   telescope_builtin.lsp_references,
--   { desc = "go to references" }
-- )
-- F.map(
--   "n",
--   "gds",
--   telescope_builtin.lsp_document_symbols,
--   { desc = "document symbols" }
-- )
-- F.map(
--   "n",
--   "gws",
--   telescope_builtin.lsp_dynamic_workspace_symbols,
--   { desc = "workspace symbols" }
-- )
-- F.map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "code lens" })
-- F.map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "symbol rename" })
-- F.map(
--   "n",
--   "<leader>aa",
--   telescope_builtin.diagnostics,
--   { desc = "all diagnostics" }
-- )

-- F.map("n", "<leader>ae", function()
--   telescope_builtin.diagnostics({ severity = "Error" })
-- end, { desc = "'Error' diagnostics" })
--
-- F.map("n", "<leader>aw", function()
--   telescope_builtin.diagnostics({ severity = "Warning" })
-- end, { desc = "'Warning' diagnostics" })

-- if client.server_capabilities.documentHighlightProvider then
--   vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--     buffer = bufnr,
--     callback = vim.lsp.buf.document_highlight,
--     group = lsp_group,
--   })
--
--   vim.api.nvim_create_autocmd("CursorMoved", {
--     buffer = bufnr,
--     callback = vim.lsp.buf.clear_references,
--     group = lsp_group,
--   })
-- end

-- if client.server_capabilities.codeLensProvider then
--   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
--     buffer = bufnr,
--     callback = vim.lsp.codelens.refresh,
--     group = lsp_group,
--   })
-- end

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "dap-repl" },
--   callback = function()
--     require("dap.ext.autocompl").attach()
--   end,
--   group = lsp_group,
-- })

-- if client.supports_method("textDocument/formatting") then
--   vim.api.nvim_create_autocmd("BufWritePre", {
--     group = lsp_group,
--     buffer = bufnr,
--     callback = function(args)
--       vim.lsp.buf.format()
--       require("conform").format({ bufnr = args.buf })
--       if vim.fn.exists(":MetalsOrganizeImports") > 0 then
--         vim.cmd("MetalsOrganizeImports")
--       end
--     end,
--   })
-- end

-- turn off semantic highlighting from lsp
-- client.server_capabilities.semanticTokensProvider = nil
-- end

local setup = function()
  -- LSP logging to debug
  -- vim.lsp.set_log_level("debug")
  -- vim.lsp.set_log_level("trace")

  -- manually enable LSP
  vim.lsp.enable({ "madlib" })
  vim.lsp.enable({ "bashls" })
  vim.lsp.enable({ "gopls" })
  vim.lsp.enable({ "vue_ls" })
  vim.lsp.enable({ "ty" })
  vim.lsp.enable({ "taplo" })
  local vue_plugin = {
    name = "@vue/typescript-plugin",
    location = "/opt/homebrew/lib/node_modules/@vue/language-server",
    languages = { "vue" },
    configNamespace = "typescript",
  }
  vim.lsp.config("vtsls", {
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            vue_plugin,
          },
        },
      },
    },
    filetypes = {
      "typescript",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "vue",
    },
  })
  vim.lsp.enable({ "vtsls" })

  -- some diagnostic settings
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.ERROR] = "",
      },
      numhl = {
        [vim.diagnostic.severity.INFO] = "InfoMsg",
        [vim.diagnostic.severity.WARN] = "WarningMsg",
        [vim.diagnostic.severity.ERROR] = "ErrorMsg",
      },
    },
    severity_sort = true,
    update_in_insert = true,
    virtual_text = false,
    virtual_lines = { current_line = true },
  })

  local lsp_attach_group = F.augroup("lsp_attach")
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    callback = function(event)
      F.map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "code lens" })
      F.map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "symbol rename" })

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        client.server_capabilities.semanticTokensProvider = nil
      end
      -- if
      --   client
      --   and client:supports_method(
      --     vim.lsp.protocol.Methods.textDocument_formatting
      --   )
      -- then
      local format_group = F.augroup("format_group")
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = format_group,
        pattern = { "*" },
        callback = function()
          vim.lsp.buf.format()
        end,
      })
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        group = format_group,
        pattern = { "*.mad" },
        callback = function()
          local view = vim.fn.winsaveview()
          vim.cmd([[silent %! madlib format -i %]])
          if vim.v.shell_error ~= 0 then
            vim.cmd.u()
          else
            vim.cmd.w()
          end
          vim.fn.winrestview(view)
        end,
      })
      -- end
      if
        client
        and client:supports_method(
          vim.lsp.protocol.Methods.textDocument_documentHighlight
        )
      then
        local highlight_group = F.augroup("highlight_group")
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
          group = highlight_group,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
          group = highlight_group,
        })
      end
      if
        client
        and client:supports_method(
          vim.lsp.protocol.Methods.textDocument_codeLens
        )
      then
        local codelens_group = F.augroup("codelens_group")
        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
          buffer = event.buf,
          callback = vim.lsp.codelens.refresh,
          group = codelens_group,
        })
      end
    end,
  })
  -- LSP for Madlib
  -- local madlib_lsp_group = F.augroup("lsp-madlib")
  -- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  --   pattern = { "*.mad" },
  --   callback = function()
  --     vim.lsp.start({
  --       name = "madlib",
  --       cmd = { "madlib", "lsp" },
  --       root_dir = vim.fs.dirname(
  --         vim.fs.find({ "madlib.json" }, { upward = true })[1]
  --       ),
  --       -- on_attach = attach_func,
  --     })
  --   end,
  --   group = madlib_lsp_group,
  -- })
  -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  --   pattern = { "*.mad" },
  --   callback = function()
  --     local view = vim.fn.winsaveview()
  --     vim.cmd([[silent %! madlib format -i %]])
  --     if vim.v.shell_error ~= 0 then
  --       vim.cmd.u()
  --     else
  --       vim.cmd.w()
  --     end
  --     vim.fn.winrestview(view)
  --   end,
  --   group = madlib_lsp_group,
  -- })
end

return {
  setup = setup,
  -- attach_func = attach_func,
}
