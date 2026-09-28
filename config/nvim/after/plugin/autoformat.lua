vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    if not require("conform").format({ bufnr = args.buf }) then
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
    end
    if vim.fn.exists(":MetalsOrganizeImports") > 0 then
      vim.cmd("MetalsOrganizeImports")
    end
  end,
  group = vim.api.nvim_create_augroup("autoformat_group", { clear = true }),
})
