return {
  "aznhe21/actions-preview.nvim",
  opts = function()
    return {
      backend = { "snacks" },
      snacks = {
        layout = {
          layout = {
            box = "vertical",
            {
              win = "preview",
              title = "{preview}",
              border = true,
            },
            {
              box = "vertical",
              border = true,
              title = "{title} {live} {flags}",
              { win = "input", height = 1,     border = "bottom" },
              { win = "list",  border = "none" },
            },
          },
        },
      },
      highlight_command = {
        require("actions-preview.highlight").delta(
          "delta --no-gitconfig --side-by-side"
        ),
      },
    }
  end,
  keys = {
    {
      "<leader>ca",
      function()
        require("actions-preview").code_actions()
      end,
      mode = { "n", "v" },
      desc = "preview code action",
    },
  },
}
