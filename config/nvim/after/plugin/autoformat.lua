vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
    if
      #(
        vim.lsp.get_clients({
          bufnr = args.buf,
          method = "textDocument/formatting",
        })
      ) > 0
    then
      vim.lsp.buf.format()
    end
    if vim.fn.exists(":MetalsOrganizeImports") > 0 then
      vim.cmd("MetalsOrganizeImports")
    end
  end,
  group = vim.api.nvim_create_augroup("autoformat_group", { clear = true }),
})
