return {
  -- rainbow csv plugin https://github.com/mechatroner/rainbow_csv
  "mechatroner/rainbow_csv",

  -- lua dev repl
  "bfredl/nvim-luadev",

  -- integration between nvim and wezterm multiplexing
  -- https://github.com/mrjones2014/smart-splits.nvim
  {
    'mrjones2014/smart-splits.nvim',
    keys = {
      { "<C-h>",  function() require("smart-splits").move_cursor_left() end,     mode = { "n", "v" } },
      { "<C-j>",  function() require("smart-splits").move_cursor_down() end,     mode = { "n", "v" } },
      { "<C-k>",  function() require("smart-splits").move_cursor_up() end,       mode = { "n", "v" } },
      { "<C-l>",  function() require("smart-splits").move_cursor_right() end,    mode = { "n", "v" } },
      { "<C-\\>", function() require("smart-splits").move_cursor_previous() end, mode = { "n", "v" } },
    },
  },

  -- integration between nvim and tmux https://github.com/christoomey/vim-tmux-navigator
  -- {
  --   "christoomey/vim-tmux-navigator",
  --   cmd = {
  --     "TmuxNavigateLeft",
  --     "TmuxNavigateDown",
  --     "TmuxNavigateUp",
  --     "TmuxNavigateRight",
  --     "TmuxNavigatePrevious",
  --   },
  --   keys = {
  --     { "<C-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>",     mode = { "n", "v" } },
  --     { "<C-h>",  "<C-o>:TmuxNavigateLeft<cr>",         mode = { "i" } },
  --     { "<C-j>",  "<cmd><C-U>TmuxNavigateDown<cr>",     mode = { "n", "v" } },
  --     { "<C-j>",  "<C-o>:TmuxNavigateDown<cr>",         mode = { "i" } },
  --     { "<C-k>",  "<cmd><C-U>TmuxNavigateUp<cr>",       mode = { "n", "v" } },
  --     { "<C-k>",  "<C-o>:TmuxNavigateUp<cr>",           mode = { "i" } },
  --     { "<C-l>",  "<cmd><C-U>TmuxNavigateRight<cr>",    mode = { "n", "v" } },
  --     { "<C-l>",  "<C-o>:TmuxNavigateRight<cr>",        mode = { "i" } },
  --     { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", mode = { "n", "v" } },
  --     { "<C-\\>", "<C-o>:TmuxNavigatePrevious<cr>",     mode = { "i" } },
  --   },
  -- },

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
        telescope = require("telescope.themes").get_ivy(),
      }
    end
  },

  -- extra movement command for changing quotes/brackets/etc. that surround other things
  "tpope/vim-surround",

  -- git plugin
  "tpope/vim-fugitive",

  -- github extensions for vim-fugutive https://github.com/tpope/vim-rhubarb
  "tpope/vim-rhubarb",

  -- use minus sign to browse file directory structure from any buffer, and adds other mappings
  -- "tpope/vim-vinegar",

  -- adds various navigation commands
  "tpope/vim-unimpaired",

  -- icons
  "kyazdani42/nvim-web-devicons",

  -- vimscript plugin for madlib
  "madlib-lang/vim-madlib",

  -- prettier ui elements for neovim https://github.com/stevearc/dressing.nvim
  {
    "stevearc/dressing.nvim",
    opts = {
      select = {
        backend = { "telescope" },
      }
    }
  },

  -- convert string casing https://github.com/johmsalas/text-case.nvim
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
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
    }
  },

  -- github plugin https://github.com/pwntester/octo.nvim
  {
    "pwntester/octo.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      }
    }
  },

  -- animate the buffer https://github.com/Eandrju/cellular-automaton.nvim
  {
    "eandrju/cellular-automaton.nvim",
    config = function()
      local slide_config = {
        fps = 60,
        name = "slide",
        update = function(grid)
          for i = 1, #grid do
            local prev = grid[i][#(grid[i])]
            for j = 1, #(grid[i]) do
              grid[i][j], prev = prev, grid[i][j]
            end
          end
          return true
        end
      }
      require("cellular-automaton").register_animation(slide_config)
    end,
    keys = {
      { "<leader>kr", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "Animate the code; make it rain" },
      { "<leader>kl", "<cmd>CellularAutomaton game_of_life<CR>", desc = "Animate the code; game of life" },
      { "<leader>ks", "<cmd>CellularAutomaton slide<CR>",        desc = "Animate the code; slide to the right" },
    }
  },

  -- plugin to enhance folding https://github.com/kevinhwang91/nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
      provider_selector = function(_, _, _)
        return { "treesitter", "indent" }
      end
    },
  },

  -- menus that show key bindings after pressing a prefix
  -- https://github.com/folke/which-key.nvim
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>h", group = "git ops" },
        { "<leader>k", group = "cellular automaton" },
        { "<leader>m", group = "nvim metals" },
      },
      plugins = {
        marks = false,
        presets = {
          windows = false,
        },
      },
      icons = {
        mappings = false,
      },
    },
    -- init = function()
    --   vim.o.timeout = true
    --   vim.o.timeoutlen = 300
    --   local wk = require("which-key")
    --   wk.register({
    --     h = {
    --       name = "git ops"
    --     },
    --     m = {
    --       name = "nvim metals"
    --     },
    --     k = {
    --       name = "cellular automaton"
    --     }
    --   }, { prefix = "<leader>" })
    -- end,
    -- config = true,
  },

  -- telescope fzf https://github.com/nvim-telescope/telescope-fzf-native.nvim
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make"
  },

  -- lua lsp setup for neovim https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua",
  },

  -- generic LSP configs for when no custom LSP plugin available
  -- https://github.com/neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      -- 'williamboman/mason.nvim',
      -- 'williamboman/mason-lspconfig.nvim',
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
    cmd = "Glow"
  },

  -- handles pairs of brackets and creating space between them when doing carriage return
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },

  -- lsp status progress handler https://github.com/j-hui/fidget.nvim
  {
    "j-hui/fidget.nvim",
    config = true,
  },

  -- metals LSP plugin
  {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
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
    config = function()
      vim.cmd.colorscheme("rose-pine-main")
    end
  },
}
