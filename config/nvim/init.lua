-- globals
local F = require("btrachey.functions")

-- set leader
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

-- lazy.nvim plugin manager
-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- load plugins
require("lazy").setup("btrachey.plugins", { install = { colorscheme = { "rose-pine" } } })

-- set up LSP
require("btrachey.lsp").setup()
-- tmux movements
-- require("btrachey.tmux").setup()

-- things I haven't figured out how to do in native lua yet
vim.cmd([[ syntax on ]])
vim.cmd([[ filetype on ]])
-- define custom symbols for non-printing chars
vim.cmd([[ set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣ ]])
-- don't fold until the first request for a fold toggle
-- vim.cmd([[ set nofoldenable ]]) -- turned off for enabling nvim-ufo
-- highlight column at max width
vim.cmd([[ set colorcolumn=+1 ]])
-- source vimrc for now
-- vim.cmd('source /users/brian.tracey/.vimrc')

-- OPTIONS
-- global
local options_settings = {
  clipboard      = "unnamed",
  completeopt    = { "menuone",
    -- "noinsert",
    -- "noselect",
    "longest",
    "popup"
  },
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
  textwidth      = 100,
  timeoutlen     = 250,
  undofile       = true,
  updatetime     = 750,
  wrap           = false,
  -- all of these are for nvim-ufo
  -- foldcolumn     = "1",
  foldlevel      = 99,
  foldlevelstart = 99,
  foldenable     = true,
  spell          = true,
}
for name, setting in pairs(options_settings) do
  vim.opt[name] = setting
end

-- don't show file info
vim.opt_global.shortmess:remove("F")
-- do not show search count in command line
vim.opt_global.shortmess:append("S")

-- custom user commands
--- print out all registered highlight groups
vim.api.nvim_create_user_command("ListHighlights",
  F.cmd_map([[ so $VIMRUNTIME/syntax/hitest.vim ]]),
  { nargs = 0 }
)

--- toggle inlay hints
vim.api.nvim_create_user_command("InlayToggle", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
  end,
  { nargs = 0 }
)

-- jk escapes insert, command, and visual modes
F.map("!", "jk", "<Esc>", { desc = "Esc remapped to j+k" })
-- command qq to replace q!
F.map("c", "qq", "q!", { desc = "qq in command mode expands to q!" })
-- tab to match bracket pairs instead of %; first remap tab to C-p
-- F.map("n", "<C-p>", "<C-i>")
-- F.map("n", "<tab>", "%")
-- F.map("v", "<tab>", "%")
-- toggle num/relativenum
F.map("n", "<leader>n", F.cmd_map("set number! relativenumber!"),
  { desc = "Toggle line & relative line num" })
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
-- -- use tab to trigger completion and move within pop up menu
-- F.map({ "i", "s" }, "<Tab>", F.tab_complete,
--   { desc = "Trigger completion/move in pop up menu.", expr = true }
-- )
-- F.map({ "i", "s" }, "<S-Tab>", F.s_tab_complete,
--   { desc = "Trigger completion/move in pop up menu.", expr = true }
-- )
-- enter selects a pop up item or general carraige return
--[[ F.map({ "i", "s" }, "<CR>", F.carriage_return,
  {
    desc = "Select item in pop up else regular <CR>.",
    expr = true
  }
) ]]

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
-- it causes problems to try to set this in the plugin setup itself
F.map({ "n", "v" }, "<leader>e", "<Plug>(Luadev-Run)")

-- recognize Jenkins files as groovy
local jenkinsfile_group = vim.api.nvim_create_augroup("jenkinsfile", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
  pattern = { "Jenkinsfile*" },
  command = "setf groovy",
  group = jenkinsfile_group
})

-- recognize .conf files as hocon
local hocon_group = vim.api.nvim_create_augroup("hocon", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
  pattern = { "*.conf" },
  command = "set ft=hocon",
  group = hocon_group
})
-- run hocon formatter
-- api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.conf" },
--   command = "%! hoconfmt",
--   group = hocon_group
-- })

-- force zshfn files to sh syntax
local zshfn_files_group = vim.api.nvim_create_augroup("zshfn_files", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
  pattern = { "/users/brian.tracey/protenus/workspace/dotfiles/zshfn/*" },
  command = "setf sh",
  group = zshfn_files_group
})

-- auto run lilypond script after buffer write
local lilypond_group = vim.api.nvim_create_augroup("lilypond_files", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.ly", "*.ily" },
  callback = function()
    local current_file_path = vim.api.nvim_buf_get_name(0)
    -- local parent_dir = string.match(current_file_path, "(.*/)[%w-_%.]*$")
    local filename = string.match(current_file_path, "([%w/-_%.]*)%.[i]?ly$")
    local target_pdf = filename .. ".pdf"
    vim.cmd("!lilypond -o " .. filename .. " %")
    print("trying to open pdf: " .. target_pdf)
    vim.ui.open(target_pdf)
    -- if (vim.fn.filereadable(vim.fn.expand(target_pdf)) == 1) then
    --   vim.cmd("!open " .. target_pdf)
    -- end
  end,
  group = lilypond_group,
})

local search_highlight_group = vim.api.nvim_create_augroup("searc_highlight_group", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved" }, {
  desc    = "turn of search highlight when moving the cursor",
  pattern = "*",
  command = ":nohlsearch",
  group   = search_highlight_group
})

-- remove 'o' and 'r' from formatoptions to prevent auto-adding comments on newlines
local comment_group = vim.api.nvim_create_augroup("comment_group", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = "*",
  desc = "Set buffer local formatoptions.",
  callback = function()
    vim.opt_local.formatoptions:remove({
      "r", -- insert comment leader after <enter> in insert mode
      "o", -- insert comment leader after 'o' or 'O' in normal mode
    })
  end,
  group = comment_group,
})

local completion_group = vim.api.nvim_create_augroup("completion_group", { clear = true })
vim.api.nvim_create_autocmd({ "TextChangedI", "TextChangedP" }, {
  group = completion_group,
  pattern = "*",
  desc = "re-trigger completion after each keypress to keep completion options menu as up to date as possible",
  callback = function()
    local line = vim.api.nvim_get_current_line()
    local cursor = vim.api.nvim_win_get_cursor(0)[2]

    local current = string.sub(line, cursor, cursor + 1)
    if current == "." or current == "," or current == " " then
      require('cmp').close()
    end

    local before_line = string.sub(line, 1, cursor + 1)
    local after_line = string.sub(line, cursor + 1, -1)
    if not string.match(before_line, '^%s+$') then
      if after_line == "" or string.match(before_line, " $") or string.match(before_line, "%.$") then
        if require("cmp").visible() then
          require('cmp').complete()
        end
      end
    end
  end,
})
