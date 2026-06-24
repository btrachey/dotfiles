local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = "/opt/homebrew/lib/node_modules/@vue/language-server",
  languages = { "vue" },
  configNamespace = "typescript",
}
return {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
}
