local set = vim.keymap.set

set("n", "<leader>i", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- jk escapes insert, command, and visual modes
set("!", "jk", "<Esc>", { desc = "Esc remapped to j+k" })
-- command qq to replace q!
set("c", "qq", "q!", { desc = "qq in command mode expands to q!" })
-- clear search or other highlighting
set("n", "<leader><space>", function()
  vim.cmd("nohlsearch")
end, { desc = "Turn off search highlighting" })
-- automatically add \v 'very magic' flag to searches
set("n", "/", "/\\v")
set("n", "?", "?\\v")
-- use shift+h/l for moving to beginning/end of line
set("", "H", "0")
set("", "L", "$")
-- ;v for vertical split, ;h for horizontal
set("n", ";v", function()
  vim.cmd("vsplit")
end, { desc = "Create vertical split." })
set("n", ";h", function()
  vim.cmd("split")
end, { desc = "Create horizontal split." })
-- toggle quickfix window
set("n", "<leader>q", function()
  local qf_active = false
  for _, data in ipairs(vim.api.nvim_list_wins()) do
    if
      vim.api.nvim_get_option_value(
        "filetype",
        { buf = vim.api.nvim_win_get_buf(data) }
      ) == "qf"
    then
      qf_active = true
    end
  end
  if qf_active then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end, { desc = "Toggle the quickfix window" })
-- exit Terminal insert mode with ctrl-k
set("t", "<C-k>", "<C-\\><C-n>")
-- resizing
set("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
set("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
-- resizing in terminal
set("t", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize up" })
set("t", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize down" })
set("t", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
set("t", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })
