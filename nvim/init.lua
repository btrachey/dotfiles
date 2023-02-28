-- globals
local F = require("btrachey.functions")
local api = vim.api

-- set leader
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- load plugins
require("btrachey.plugins").setup()
-- set up LSP
require("btrachey.lsp").setup()
-- treesitter config
require("btrachey.plugins.treesitter").setup()
-- tmux movements
require("btrachey.tmux").setup()


-- things I haven't figured out how to do in native lua yet
vim.cmd([[ syntax on ]])
vim.cmd([[ filetype on ]])
-- define custom symbols for non-printing chars
vim.cmd([[ set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣ ]])
-- don't fold until the first request for a fold toggle
vim.cmd([[ set nofoldenable ]])
-- highlight column at max width
vim.cmd([[ set colorcolumn=+1 ]])
-- source vimrc for now
vim.cmd('source /users/brian.tracey/.vimrc')

-- OPTIONS
-- global
local options_settings = {
  backspace      = { "indent", "eol", "start" },
  clipboard      = "unnamed",
  completeopt    = { "menuone", "noinsert", "noselect" },
  cursorline     = true,
  cursorlineopt  = "number",
  expandtab      = true,
  hlsearch       = true,
  ignorecase     = true,
  incsearch      = true,
  laststatus     = 2,
  linebreak      = true,
  number         = true,
  relativenumber = true,
  scrolloff      = 5,
  shiftwidth     = 2,
  showmatch      = true,
  smartcase      = true,
  smarttab       = true,
  softtabstop    = 2,
  textwidth      = 99,
  timeoutlen     = 250,
  undofile       = true,
  updatetime     = 750,
  wrap           = false,
}
for name, setting in pairs(options_settings) do
  vim.opt[name] = setting
end

-- don't show file info
vim.opt_global.shortmess:remove("F")
-- stop ins-completion-menu messages
vim.opt_global.shortmess:append("c")

-- custom bitbucket domain for vim-fubitive plugin
vim.g.fubitive_domain_pattern = "stash.protenus.com"

-- delimitMate plugin
-- expand carriage return
vim.g.delimitMate_expand_cr = 2

-- custom user commands
--- print out all registered highlight groups
api.nvim_create_user_command("ListHighlights",
  F.cmd_map([[ so $VIMRUNTIME/syntax/hitest.vim ]]),
  { nargs = 0 }
)

-- jk escapes insert, command, and visual modes
F.map("!", "jk", "<Esc>", { desc = "Esc remapped to j+k" })
-- command qq to replace q!
F.map("c", "qq", "q!", { desc = "qq in command mode expands to q!" })
-- tab to match bracket pairs instead of %; first remap tab to C-p
F.map("n", "<C-p>", "<C-i>")
F.map("n", "<tab>", "%")
F.map("v", "<tab>", "%")
-- toggle num/relativenum
F.map("n", "<leader>n", F.cmd_map("set number! relativenumber!"),
  { desc = "Toggle line & relative line num" })
-- ctrl-b for command prefix instead of ctrl-w
F.map("n", "<C-b>", "<C-w>")
-- clear search or other highlighting
F.map("n", "<leader><space>", F.cmd_map("nohlsearch"), { desc = "Turn off search highlighting" })
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
-- use tab to trigger completion and move within pop up menu
F.map({ "i", "s" }, "<Tab>", F.tab_complete,
  { desc = "Trigger completion/move in pop up menu.", expr = true }
)
F.map({ "i", "s" }, "<S-Tab>", F.s_tab_complete,
  { desc = "Trigger completion/move in pop up menu.", expr = true }
)
-- enter selects a pop up item or general carraige return
F.map({ "i", "s" }, "<CR>", F.carriage_return,
  { desc = "Select item in pop up else regular <CR>.",
    expr = true }
)
-- resizing
F.map("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize up" })
F.map("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize down" })
F.map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize left" })
F.map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize right" })
-- resizing in terminal
F.map("t", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize up" })
F.map("t", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize down" })
F.map("t", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize left" })
F.map("t", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize right" })

-- generally available lua function for dumping out table content
_G.tableDump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. tableDump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- autocmds
-- workaround for packer https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufAdd', 'BufNew', 'BufNewFile', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
  callback = function()
    vim.opt.foldmethod = 'expr'
    vim.opt.foldexpr   = 'nvim_treesitter#foldexpr()'
  end
})

-- recognize Jenkins files as groovy
local jenkinsfile_group = api.nvim_create_augroup("jenkinsfile", { clear = true })
api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
  pattern = { "Jenkinsfile*" },
  command = "setf groovy",
  group = jenkinsfile_group
})

-- force zshfn files to sh syntax
local zshfn_files_group = api.nvim_create_augroup("zshfn_files", { clear = true })
api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
  pattern = { "/users/brian.tracey/protenus/workspace/dotfiles/zshfn/*" },
  command = "setf sh",
  group = zshfn_files_group
})

-- auto run lilypond script after buffer write
local lilypond_group = api.nvim_create_augroup("lilypond_files", { clear = true })
api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.ly", "*.ily" },
  command = "!~/.make_pdf.sh %",
  group = lilypond_group,
})

-- add :Source command
local nvim_conf_group = api.nvim_create_augroup("nvim_conf", { clear = true })
api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
  pattern = { "*/nvim/init.lua", ".vimrc" },
  callback = function(opts)
    local write_and_source = function()
      api.nvim_command("write")
      api.nvim_command("source %")
    end
    api.nvim_buf_create_user_command(opts.buf, "Source", write_and_source, { nargs = 0 })
  end,
  group = nvim_conf_group,
})
api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*/nvim/init.lua", "*/nvim/lua/**/*" },
  callback = function(opts)
    vim.cmd([[ source $MYVIMRC | silent! LspStop | silent! LspStart | PackerCompile ]])
  end,
  group = nvim_conf_group
})
