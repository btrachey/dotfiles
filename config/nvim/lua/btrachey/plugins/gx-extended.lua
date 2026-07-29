return {
  "rmagatti/gx-extended.nvim",
  keys = { "gx" },
  config = function()
    require("gx-extended").setup({
      enable_jira_tickets = true,
    })
  end,
}
