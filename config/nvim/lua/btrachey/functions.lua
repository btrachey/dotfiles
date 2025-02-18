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

return {
  table_dump = table_dump,
  cmd_map = cmd_map,
  map = map,
  toggleqf = toggleqf,
}
