return {
  -- https://github.com/karb94/neoscroll.nvim
  {
    "karb94/neoscroll.nvim",
    opts = {
      easing = "quadratic",
    },
  },

  -- https://github.com/lervag/vimtex?tab=readme-ov-file
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "skim"
    end,
    -- dependencies = {
    -- { "iurimateus/luasnip-latex-snippets.nvim", config = true },
    -- },
  },

  -- rainbow csv plugin https://github.com/mechatroner/rainbow_csv
  "mechatroner/rainbow_csv",

  -- extra movement command for changing quotes/brackets/etc. that surround other things
  "tpope/vim-surround",

  -- git plugin
  "tpope/vim-fugitive",

  -- github extensions for vim-fugutive https://github.com/tpope/vim-rhubarb
  "tpope/vim-rhubarb",

  -- vimscript plugin for madlib
  "madlib-lang/vim-madlib",

  -- 'w' and related moves within SUBwords as well https://github.com/chrisgrieser/nvim-spider
  {
    "chrisgrieser/nvim-spider",
    opts = {
      skipInsignificantPunctuation = false,
    },
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
      },
    },
  },

  -- plugin to enhance folding https://github.com/kevinhwang91/nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end,
    },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        mode = { "n", "v" },
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        mode = { "n", "v" },
      },
      {
        "K",
        function()
          local winid
          require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        mode = { "n", "v" },
      },
    },
  },

  -- lua lsp setup for neovim https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = {
      { "DrKJeff16/wezterm-types", lazy = true },
    },
    opts = {
      library = {
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = true,
      automatic_enable = true,
      ensure_installed = require("btrachey.lsp").servers,
    },
    dependencies = {
      {
        "mason-org/mason.nvim",
        config = true,
      },
      "neovim/nvim-lspconfig",
    },
  },

  -- lilypond plugin https://github.com/martineausimon/nvim-lilypond-suite
  {
    "martineausimon/nvim-lilypond-suite",
    ft = "lilypond",
    config = true,
  },

  -- handles pairs of brackets and creating space between them when doing carriage return
  -- {
  --   "windwp/nvim-autopairs",
  --   event = "InsertEnter",
  --   config = true,
  -- },

  -- lsp status progress handler https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        ignore_done_already = true,
      },
    },
  },

  -- colorscheme
  {
    "rose-pine/neovim",
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    opts = {
      highlight_groups = {
        LspCodeLens = { fg = "subtle", italic = true },
      },
    },
    init = function()
      vim.cmd.colorscheme("rose-pine-main")
    end,
  },
}
