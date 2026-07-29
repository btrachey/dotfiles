local set = vim.keymap.set

local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "gopls",
  "jsonls",
  "lua_ls",
  "marksman",
  "ruff",
  "superhtml",
  "taplo",
  "ty",
  "ts_ls",
  "yamlls",
}

local nonMasonServers = { "bufls", "madlib" }

local setup = function()
  -- LSP logging to debug
  -- vim.lsp.set_log_level("debug")
  -- vim.lsp.set_log_level("trace")

  local allServers = vim.tbl_extend("force", servers, nonMasonServers)
  -- manually enable LSP
  for _, lsp in ipairs(allServers) do
    vim.lsp.enable(lsp)
  end

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

  local lsp_attach_group =
      vim.api.nvim_create_augroup("lsp_attach", { clear = true })
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    callback = function(event)
      set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "code lens" })
      set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "symbol rename" })

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client then
        client.server_capabilities.semanticTokensProvider = nil
      end
      if
          client
          and client:supports_method(
            vim.lsp.protocol.Methods.textDocument_documentHighlight
          )
      then
        local highlight_group =
            vim.api.nvim_create_augroup("highlight_group", { clear = true })
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
      -- if
      --   client
      --   and client:supports_method(
      --     vim.lsp.protocol.Methods.textDocument_codeLens
      --   )
      -- then
      --   local codelens_group = F.augroup("codelens_group")
      --   vim.api.nvim_create_autocmd(
      --     { "BufEnter", "BufWritePost", "CursorHold", "InsertLeave" },
      --     {
      --       buffer = event.buf,
      --       callback = vim.lsp.codelens.enable,
      --       group = codelens_group,
      --     }
      --   )
      -- end
    end,
  })
end

return {
  servers = servers,
  setup = setup,
}
