local F = require("btrachey.functions")

local function setup()
  F.map("n", "<leader>i", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "Toggle inlay hints" })

  -- jk escapes insert, command, and visual modes
  F.map("!", "jk", "<Esc>", { desc = "Esc remapped to j+k" })
  -- command qq to replace q!
  F.map("c", "qq", "q!", { desc = "qq in command mode expands to q!" })
  -- clear search or other highlighting
  F.map(
    "n",
    "<leader><space>",
    F.cmd_map("nohlsearch"),
    { desc = "Turn off search highlighting" }
  )
  -- automatically add \v 'very magic' flag to searches
  F.map("n", "/", "/\\v")
  F.map("n", "?", "?\\v")
  -- use shift+h/l for moving to beginning/end of line
  F.map("", "H", "0")
  F.map("", "L", "$")
  -- ;v for vertical split, ;h for horizontal
  F.map("n", ";v", F.cmd_map("vsplit"), { desc = "Create vertical split." })
  F.map("n", ";h", F.cmd_map("split"), { desc = "Create horizontal split." })
  -- toggle quickfix window
  F.map("n", "<leader>q", F.toggleqf, { desc = "Toggle the quickfix window" })
  -- exit Terminal insert mode with ctrl-k
  F.map("t", "<C-k>", "<C-\\><C-n>")
  -- resizing
  F.map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
  F.map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
  F.map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
  F.map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
  -- resizing in terminal
  F.map("t", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize up" })
  F.map("t", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize down" })
  F.map(
    "t",
    "<C-Left>",
    "<cmd>vertical resize -2<CR>",
    { desc = "Resize left" }
  )
  F.map(
    "t",
    "<C-Right>",
    "<cmd>vertical resize +2<CR>",
    { desc = "Resize right" }
  )
  -- it causes problems to try to set this in the plugin setup itself
  F.map({ "n", "v" }, "<leader>e", "<Plug>(Luadev-Run)")
end

return {
  setup = setup,
}
