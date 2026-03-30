-- dump a lua table to string
local function table_dump(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. table_dump(v) .. ","
    end
    return s .. "} "
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
    table.insert(
      filetypes,
      vim.api.nvim_get_option_value(
        "filetype",
        { buf = vim.api.nvim_win_get_buf(data) }
      )
    )
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

local function dir_has_file(dir, file)
  return require("lspconfig").util.search_ancestors(dir, function(path)
    local abs_path = table.concat({ path, file }, "/")
    if (vim.loop.fs_stat(abs_path) or {}).type == "file" then
      return true
    end
  end)
end

local function augroup(name, clear)
  local c = clear == nil and true or clear
  return vim.api.nvim_create_augroup(name, { clear = c })
end

local function find_scala_test_file()
  local current_filepath = vim.api.nvim_buf_get_name(0)
  local spec_filename = string.format(
    "%sSpec%s",
    string.match(current_filepath, ".*/(.*)(.scala)$")
  )
  --[[ assume the workspace only has one folder and it's the one we want;
        a little naïve, but effective for now ]]
  local base_dir = vim.lsp.buf.list_workspace_folders()[1]
  local resolved_spec_file = vim.fs.find(spec_filename, { path = base_dir })
  if resolved_spec_file[1] then
    vim.cmd("e " .. resolved_spec_file[1])
  else
    Snacks.picker.files({ pattern = spec_filename })
  end
end

return {
  augroup = augroup,
  cmd_map = cmd_map,
  dir_has_file = dir_has_file,
  find_scala_test_file = find_scala_test_file,
  map = map,
  table_dump = table_dump,
  toggleqf = toggleqf,
}
