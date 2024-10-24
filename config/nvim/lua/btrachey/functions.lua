local api = vim.api

local function get_visual(_, parent)
  local ls = require("luasnip")
  local sn = ls.snippet_node
  local i = ls.insert_node

  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- dump a lua table to string
local function table_dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. table_dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- shortcut for key remaps
local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- wrap vim.cmd calls in another function to enable usage in keybinds
local function cmd_map(command)
  return function()
    vim.cmd(command)
  end
end

-- Expand the functionality of shift-k to do the LSP hover action
-- or close the hover window if we are inside the hover
local function shiftk()
  local win = api.nvim_get_current_win()
  local win_config = api.nvim_win_get_config(win)
  if win_config.relative ~= "" then
    vim.cmd('close')
  else
    vim.lsp.buf.hover()
  end
end

local function toggleqf()
  local filetypes = {}
  for _, data in ipairs(vim.api.nvim_list_wins()) do
    table.insert(filetypes, vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(data) }))
  end
  local function has_value(table, comp)
    for _, value in ipairs(table) do
      if value == comp then
        return true
      end
    end
    return false
  end

  if has_value(filetypes, "qf") then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

-- Use tab in completion menus
local function check_back_space()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end
-- alternative way to check for tab complete
local function has_words_before()
  local unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

--- Use (s-)tab to:
--- move to prev/next item in completion menu
--- jump to prev/next snippet's placeholder
local function tab_complete()
  if vim.fn.pumvisible() == 1 then
    return "<C-n>"
    -- elseif vim.fn['vsnip#available'](1) == 1 then
    --   return t "<Plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return "<Tab>"
  else
    return "<C-x><C-o>"
  end
end
--- Use (s-)tab to:
--- move to prev/next item in completion menu
--- jump to prev/next snippet's placeholder
local function s_tab_complete()
  if vim.fn.pumvisible() == 1 then
    return "<C-p>"
    -- elseif vim.fn['vsnip#jumpable'](-1) == 1 then
    --   return t "<Plug>(vsnip-jump-prev)"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return "<S-Tab>"
  end
end

-- Enter selects completion
local function carriage_return()
  if vim.fn.pumvisible() == 1 then
    return "<C-y>"
  else
    return "<Plug>delimitMateCR"
  end
end

return {
  table_dump = table_dump,
  carriage_return = carriage_return,
  cmd_map = cmd_map,
  has_words_before = has_words_before,
  map = map,
  shiftk = shiftk,
  s_tab_complete = s_tab_complete,
  tab_complete = tab_complete,
  toggleqf = toggleqf,
  get_visual = get_visual
}
