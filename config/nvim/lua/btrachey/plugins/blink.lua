return {
  "saghen/blink.cmp",
  version = "v0.*",
  dependencies = {
    {
      "kristijanhusak/vim-dadbod-completion",
    },
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      opts = function()
        require("luasnip.loaders.from_lua").load({
          paths = { vim.fn.stdpath("config") .. "/lua/btrachey/snippets/" },
        })
        return {
          enable_autosnippets = true,
          update_events = { "TextChanged", "TextChangedI" },
          cut_selection_keys = "<Tab>",
        }
      end,
    },
    {
      "junkblocker/blink-cmp-wezterm",
    },
  },
  opts = {
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono",
    },
    snippets = {
      preset = "luasnip",
    },
    cmdline = {
      enabled = false,
    },
    sources = {
      default = { "lazydev", "lsp", "path", "snippets", "wezterm" },
      per_filetype = {
        sql = { "dadbod", "buffer" },
        mysql = { "dadbod", "buffer" },
      },
      providers = {
        wezterm = {
          module = "blink-cmp-wezterm",
          name = "wezterm",
          opts = {
            all_panes = true,
            capture_history = false,
            triggered_only = true,
            trigger_chars = { ">" },
          },
        },
        dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    signature = {
      enabled = true,
    },
    completion = {
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind" },
          },
        },
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      documentation = {
        auto_show = true,
        window = {
          border = "rounded",
        },
      },
      ghost_text = {
        enabled = true,
      },
      trigger = {
        prefetch_on_insert = false,
      },
    },
  },
}
