-- globals
local F = require("btrachey.functions")

-- debugging functions
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd

local x = 1
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
require("lazy").setup(
  "btrachey.plugins",
  { install = { colorscheme = { "rose-pine" } } }
)

-- set up LSP
require("btrachey.lsp").setup()
require("btrachey.mappings").setup()

-- OPTIONS
-- global
local options_settings = {
  clipboard = "unnamed",
  completeopt = {
    "menuone",
    -- "noinsert",
    -- "noselect",
    -- "longest",
    "popup",
  },
  cursorline = true,
  cursorlineopt = "number",
  expandtab = true,
  hlsearch = true,
  ignorecase = true,
  incsearch = true,
  laststatus = 2,
  linebreak = true,
  number = true,
  relativenumber = true,
  scrolloff = 5,
  shiftwidth = 2,
  showmatch = true,
  smartcase = true,
  smarttab = true,
  softtabstop = 2,
  -- textwidth = 100,
  textwidth = 80,
  timeoutlen = 250,
  undofile = true,
  updatetime = 750,
  wrap = false,
  -- all of these are for nvim-ufo
  -- foldcolumn = "1",
  foldlevel = 99,
  foldlevelstart = 99,
  foldenable = true,
  spell = true,
  winborder = "rounded",
}
for name, setting in pairs(options_settings) do
  vim.opt[name] = setting
end

-- things I haven't figured out how to do in native lua yet
-- vim.cmd([[ syntax on ]])
vim.cmd([[ filetype plugin indent on ]])
-- define custom symbols for non-printing chars
vim.cmd(
  [[ set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣ ]]
)
-- don't fold until the first request for a fold toggle
-- vim.cmd([[ set nofoldenable ]]) -- turned off for enabling nvim-ufo
-- highlight column at max width
vim.cmd([[ set colorcolumn=+1 ]])
-- source vimrc for now
-- vim.cmd('source /users/brian.tracey/.vimrc')

-- don't show file info
vim.opt_global.shortmess:remove("F")
-- do not show search count in command line
vim.opt_global.shortmess:append("S")

-- custom user commands
--- print out all registered highlight groups
vim.api.nvim_create_user_command(
  "ListHighlights",
  F.cmd_map([[ so $VIMRUNTIME/syntax/hitest.vim ]]),
  { nargs = 0 }
)

--- toggle inlay hints
vim.api.nvim_create_user_command("InlayToggle", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
end, { nargs = 0 })

-- run hocon formatter
-- api.nvim_create_autocmd({ "BufWritePre" }, {
--   pattern = { "*.conf" },
--   command = "%! hoconfmt",
--   group = hocon_group
-- })

-- zshfn files get zsh syntax
vim.filetype.add({
  pattern = {
    [".*/zshfn/.*"] = "zsh",
  },
})

-- auto run lilypond script after buffer write
local lilypond_group =
  vim.api.nvim_create_augroup("lilypond_files", { clear = true })
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
  end,
  group = lilypond_group,
})

-- remove 'o' and 'r' from formatoptions to prevent auto-adding comments on newlines
local comment_group =
  vim.api.nvim_create_augroup("comment_group", { clear = true })
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
