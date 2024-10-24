-- https://github.com/hrsh7th/nvim-cmp
return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  version = false,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    return {
      completion = {
        autocomplete = false,
        completeopt = "menu,menuone,noinsert"
      },
      view = {
        entries = { name = "custom", selection_order = "near_cursor" },
      },
      sorting = defaults.sorting,
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end
      }),
      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
      },
    }
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.setup(opts)
    cmp.event:on(
      "confirm_done",
      cmp_autopairs.on_confirm_done()
    )
    require("luasnip.loaders.from_snipmate").load()
  end,
}
