local module = {}

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

return module
