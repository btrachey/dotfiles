local F = require("btrachey.functions")
local telescope_builtin = require("telescope.builtin")
local lsp_group = vim.api.nvim_create_augroup("lsp", { clear = true })

-- add border to floating windows
-- local float_config = {
--   border = "rounded",
--   source = "if_many",
-- }

local attach_func = function(client, bufnr)
  -- LSP mappings
  F.map(
    "n",
    "gd",
    telescope_builtin.lsp_definitions,
    { desc = "go to definition" }
  )
  F.map(
    "n",
    "gi",
    telescope_builtin.lsp_implementations,
    { desc = "go to implementation" }
  )
  F.map(
    "n",
    "gr",
    telescope_builtin.lsp_references,
    { desc = "go to references" }
  )
  F.map(
    "n",
    "gds",
    telescope_builtin.lsp_document_symbols,
    { desc = "document symbols" }
  )
  F.map(
    "n",
    "gws",
    telescope_builtin.lsp_dynamic_workspace_symbols,
    { desc = "workspace symbols" }
  )
  F.map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "code lens" })
  -- F.map(
  --   "n",
  --   "<leader>sh",
  --   vim.lsp.buf.signature_help,
  --   { desc = "function signature help" }
  -- )
  -- F.map(
  --   "i",
  --   "<C-h>",
  --   vim.lsp.buf.signature_help,
  --   { desc = "function signature help" }
  -- )
  F.map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "symbol rename" })
  F.map(
    "n",
    "<leader>aa",
    telescope_builtin.diagnostics,
    { desc = "all diagnostics" }
  )

  F.map("n", "<leader>ae", function()
    telescope_builtin.diagnostics({ severity = "Error" })
  end, { desc = "'Error' diagnostics" })

  F.map("n", "<leader>aw", function()
    telescope_builtin.diagnostics({ severity = "Warning" })
  end, { desc = "'Warning' diagnostics" })

  -- F.map("n", "[d", function()
  --   vim.diagnostic.jump({ count = -1, float = false })
  -- end, { desc = "Previous diagnostic" })
  --
  -- F.map("n", "]d", function()
  --   vim.diagnostic.jump({ count = 1, float = false })
  -- end, { desc = "Next diagnostic" })

  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
      group = lsp_group,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
      group = lsp_group,
    })
  end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
      buffer = bufnr,
      callback = vim.lsp.codelens.refresh,
      group = lsp_group,
    })
  end

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "dap-repl" },
    callback = function()
      require("dap.ext.autocompl").attach()
    end,
    group = lsp_group,
  })

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = lsp_group,
      buffer = bufnr,
      callback = function(args)
        vim.lsp.buf.format()
        require("conform").format({ bufnr = args.buf })
        if vim.fn.exists(":MetalsOrganizeImports") > 0 then
          vim.cmd("MetalsOrganizeImports")
        end
      end,
    })
  end

  -- turn off semantic highlighting from lsp
  client.server_capabilities.semanticTokensProvider = nil
end

local setup = function()
  -- LSP logging to debug
  -- vim.lsp.set_log_level("debug")
  -- vim.lsp.set_log_level("trace")

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
    -- virtual_lines = false,
    -- float = float_config,
  })

  -- LSP for Madlib
  local madlib_lsp_group =
    vim.api.nvim_create_augroup("lsp-madlib", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.mad" },
    callback = function()
      vim.lsp.start({
        name = "madlib",
        cmd = { "madlib", "lsp" },
        root_dir = vim.fs.dirname(
          vim.fs.find({ "madlib.json" }, { upward = true })[1]
        ),
        on_attach = attach_func,
      })
    end,
    group = madlib_lsp_group,
  })
  vim.api.nvim_create_autocmd({ "BufWritePost" }, {
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
    group = madlib_lsp_group,
  })
end

return {
  setup = setup,
  attach_func = attach_func,
}
