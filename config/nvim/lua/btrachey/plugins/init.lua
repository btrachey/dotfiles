return {
  -- https://github.com/abecodes/tabout.nvim
  {
    "abecodes/tabout.nvim",
    config = true,
  },

  -- rainbow csv plugin https://github.com/mechatroner/rainbow_csv
  "mechatroner/rainbow_csv",

  -- lua dev repl
  {
    "yarospace/lua-console.nvim",
    lazy = true,
    keys = {
      { "`", desc = "Lua console - toggle" },
      { "<Leader>`", desc = "Lua console - attach to buf" },
    },
    opts = {},
  },

  -- integration between nvim and wezterm multiplexing
  -- https://github.com/mrjones2014/smart-splits.nvim
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = { "n", "v" },
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { "n", "v" },
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { "n", "v" },
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { "n", "v" },
      },
      {
        "<C-\\>",
        function()
          require("smart-splits").move_cursor_previous()
        end,
        mode = { "n", "v" },
      },
    },
  },

  {
    "aznhe21/actions-preview.nvim",
    opts = function()
      return {
        highlight_command = {
          require("actions-preview.highlight").delta(),
        },
        diff = {
          algorithm = "patience",
          ignore_whitespace = true,
        },
        backend = { "snacks" },
        snacks = { layout = { preset = "bottom" } },
      }
    end,
    keys = function()
      return {
        {
          "<leader>ca",
          require("actions-preview").code_actions,
          mode = { "n", "v" },
          desc = "preview code action",
        },
      }
    end,
  },

  -- better ways to work with and search & replace text
  "tpope/vim-abolish",

  -- extra movement command for changing quotes/brackets/etc. that surround other things
  "tpope/vim-surround",

  -- git plugin
  "tpope/vim-fugitive",

  -- github extensions for vim-fugutive https://github.com/tpope/vim-rhubarb
  "tpope/vim-rhubarb",

  -- adds various navigation commands
  -- "tpope/vim-unimpaired",

  -- icons
  "kyazdani42/nvim-web-devicons",

  -- vimscript plugin for madlib
  "madlib-lang/vim-madlib",

  -- convert string casing https://github.com/johmsalas/text-case.nvim
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = true,
  },

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

  -- github plugin https://github.com/pwntester/octo.nvim
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
      -- "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      picker = "snacks",
      --   suppress_missing_scope = {
      --     projects_v2 = true,
      --   },
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
  },

  -- telescope fzf https://github.com/nvim-telescope/telescope-fzf-native.nvim
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
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

  -- generic LSP configs for when no custom LSP plugin available
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      {
        "williamboman/mason.nvim",
        config = true,
        lazy = false,
      },
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- lilypond plugin https://github.com/martineausimon/nvim-lilypond-suite
  {
    "martineausimon/nvim-lilypond-suite",
    ft = "lilypond",
    config = true,
  },

  -- Glow for markdown https://github.com/charmbracelet/glow
  -- in nvim https://github.com/ellisonleao/glow.nvim
  {
    "ellisonleao/glow.nvim",
    config = true,
    cmd = "Glow",
  },

  -- handles pairs of brackets and creating space between them when doing carriage return
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- lsp status progress handler https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    opts = {
      progress = {
        ignore_done_already = true,
        -- ignore_empty_message = true
      },
      -- notification = {
      --   override_vim_notify = true,
      -- },
    },
  },

  -- rust-analyzer plugin
  {
    "simrat39/rust-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
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
