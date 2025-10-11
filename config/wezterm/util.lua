local module = {}

-- return last item in an array which satisfies the predicate
function module.last_by(arr, func)
  local res = nil
  for _, v in ipairs(arr) do
    if func(v) then
      res = v
    end
  end
  return res
end

-- extend config.keys object to not override previously defined mappings
function module.add_keys(config, new_mappings)
  local orig_keys = config.keys or {}
  for _, v in ipairs(new_mappings) do
    table.insert(orig_keys, v)
  end
  config.keys = orig_keys
end

-- extend config.key_tables object to not override previously defined mappings
function module.add_key_table(config, new_mappings)
  local orig_config = config.key_tables or {}
  for k, v in pairs(new_mappings) do
    orig_config[k] = v
  end
  config.key_tables = orig_config
end

function module.split(str, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  for s in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(t, s)
  end
  return t
end

function module.last(table)
  local len = (table and #table or false)
  if len then
    return table[len]
  else
    error("table empty or does not exist")
  end
end

return module
