return {
  cmd = {
    "taplo",
    "lsp",
    "--config",
    vim.fn.expand("~/.dotfiles/.taplo.toml"),
    "stdio",
  },
  settings = {
    taplo = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/yannh/kubernetes-json-schema/refs/heads/master/v1.32.1-standalone-strict/all.json"] = "/*.k8s.yaml",
      },
    },
  },
}
