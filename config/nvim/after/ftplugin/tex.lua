local vimtex_group = vim.api.nvim_create_augroup("vimtex", { clear = true })
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "VimtexEventViewReverse",
  callback = function()
    vim.cmd([[silent execute "!open -a WezTerm"]])
    vim.cmd([[redraw!]])
  end,
  group = vimtex_group,
})
