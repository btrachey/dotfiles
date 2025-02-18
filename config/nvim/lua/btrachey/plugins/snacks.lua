return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      sections = {
        {
          align = "right",
          text = {
            [[
░   ░░░  ░░        ░░░      ░░
▒    ▒▒  ▒▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒
▓  ▓  ▓  ▓▓      ▓▓▓▓  ▓▓▓▓  ▓
█  ██    ██  ████████  ████  █
█  ███   ██        ███      ██
]],
            hl = "header",
          }
        },
        {
          pane = 2,
          text = {
            [[
░  ░░░░  ░░        ░░  ░░░░  ░
▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒   ▒▒   ▒
▓▓  ▓▓  ▓▓▓▓▓▓  ▓▓▓▓▓        ▓
███    ███████  █████  █  █  █
████  █████        ██  ████  █
]],
            hl = "header",
          }
        },
        {
          section = "keys",
          gap = 1,
          padding = 1
        },
        { section = "startup" },
        {
          pane = 2,
          icon = " ",
          title = "Projects",
          section = "projects",
          indent = 2,
          padding = 1
        },
        {
          pane = 2,
          section = "terminal",
          cmd = "wttr",
          ttl = 30 * 60,
          padding = 1
        }
      },
    }
  }
}
