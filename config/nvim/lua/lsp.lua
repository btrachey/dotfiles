local servers = {
  "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "gopls",
  "jsonls",
  "lua_ls",
  "marksman",
  "ruff",
  "superhtml",
  "taplo",
  "ty",
  "ts_ls",
  "yamlls",
}

local nonMasonServers = {
  "protols",
  "hls",
  "madlib",
  "sourcekit",
}

return {
  servers = servers,
  nonMasonServers = nonMasonServers,
}
