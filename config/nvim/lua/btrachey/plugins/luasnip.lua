-- snippets https://github.com/L3MON4D3/LuaSnip
return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  dependencies = {
    -- {
    --   "rafamadriz/friendly-snippets",
    --   config = function()
    --     require("luasnip.loaders.from_vscode").lazy_load()
    --   end,
    -- },
    {
      "nvim-cmp",
      dependencies = {
        "saadparwaiz1/cmp_luasnip",
      },
      opts = function(_, opts)
        opts.snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        }
        table.insert(opts.sources, { name = "luasnip" })
      end,
    },
  },
  opts = function()
    require("luasnip.loaders.from_lua").load({ paths = { vim.fn.stdpath("config") .. "/lua/btrachey/snippets/" } })
    return {
      history = true,
      delete_check_events = "TextChanged",
      enable_autosnippets = true,
      update_events = { "TextChanged", "TextChangedI" },
      store_selection_keys = "<Tab>",
    }
  end,
  keys = {
    {
      "<tab>",
      function()
        return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
      end,
      expr = true,
      silent = true,
      mode = "i",
    },
    { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
    { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
  }
}
