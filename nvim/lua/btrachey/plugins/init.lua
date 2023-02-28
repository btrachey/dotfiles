local function setup()
  -- Install Packer if not already installed
  local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
      vim.cmd [[packadd packer.nvim]]
      return true
    end
    return false
  end

  local is_packer_bootstrap = ensure_packer()

  require('packer').startup(function(use)
    -- packer can manage itself
    use 'wbthomason/packer.nvim'

    -- colorscheme
    use {
      'rose-pine/neovim',
      as = 'rose-pine',
      config = function()
        vim.cmd([[ colorscheme rose-pine ]])
      end,
    }

    -- handles pairs of brackets and creating space between them when doing carriage return
    use 'Raimondi/delimitMate' -- do I still need this?

    -- extra movement command for changing quotes/brackets/etc. that surround other things
    use 'tpope/vim-surround'

    -- git plugin
    use 'tpope/vim-fugitive'

    -- gitlab extensions for vim-fugitive https://github.com/shumphrey/fugitive-gitlab.vim
    use 'shumphrey/fugitive-gitlab.vim'

    -- bitbucket extension for vim-fugitive https://github.com/tommcdo/vim-fubitive
    use 'tommcdo/vim-fubitive'

    -- shorcuts for commenting lines
    use 'tpope/vim-commentary'

    -- use minus sign to browse file directory structure from any buffer, and adds other mappings
    use 'tpope/vim-vinegar'

    -- metals LSP plugin
    use {
      'scalameta/nvim-metals',
      requires = { 'nvim-lua/plenary.nvim' },
    }

    -- generic debug plugin
    use 'mfussenegger/nvim-dap'

    -- lsp status progress handler https://github.com/j-hui/fidget.nvim
    use {
      'j-hui/fidget.nvim',
      config = function()
        require("fidget").setup()
      end
    }

    -- generic LSP config for when no custom LSP plugin available
    use {
      'neovim/nvim-lspconfig',
      requires = {
        -- Automatically install LSPs to stdpath for neovim
        -- 'williamboman/mason.nvim',
        -- 'williamboman/mason-lspconfig.nvim',
        'folke/neodev.nvim'
      }
    }

    -- annotations and keyboard shortcuts for git
    use {
      'lewis6991/gitsigns.nvim',
      tag = '*',
      config = require("btrachey.plugins.gitsigns").setup()
    }

    -- icons
    use 'kyazdani42/nvim-web-devicons'

    -- plugin to manage status line
    use {
      'nvim-lualine/lualine.nvim',
      config = require("btrachey.plugins.lualine").setup()
    }

    -- managed UI for nvim-dap
    -- use 'rcarriga/nvim-dap-ui' -- do I still need this?

    -- nvim tree-sitter
    use { 'nvim-treesitter/nvim-treesitter',
      run = function()
        pcall(require('nvim-treesitter.install').update { with_sync = true })
      end
      -- config = require("btrachey.plugins.treesitter").setup()
    }

    -- tree-sitter text objects; https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    use {
      'nvim-treesitter/nvim-treesitter-textobjects',
      after = 'nvim-treesitter'
      -- config = require("btrachey.plugins.treesitter").setup()
    }

    -- Glow in nvim https://github.com/charmbracelet/glow
    use 'ellisonleao/glow.nvim'

    -- Telescope plugin https://github.com/nvim-telescope/telescope.nvim
    use {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      requires = { 'nvim-lua/plenary.nvim' },
      config = require("btrachey.plugins.telescope").setup()
    }

    -- telescope fzf https://github.com/nvim-telescope/telescope-fzf-native.nvim
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make', cond = vim.fn.executable 'make' == 1
    }

    -- menus that show key bindings after pressing a prefix https://github.com/folke/which-key.nvim
    use {
      'folke/which-key.nvim',
      config = function()
        require("which-key").setup {}
      end
    }

    -- prettier ui elements for neovim https://github.com/stevearc/dressing.nvim
    use 'stevearc/dressing.nvim'

    if is_packer_bootstrap then
      require('packer').sync()
    end
  end)

  if is_packer_bootstrap then
    print '=================================='
    print '    Plugins are being installed   '
    print '    Wait until Packer completes,  '
    print '       then restart nvim          '
    print '=================================='
    return
  end
end

return {
  setup = setup
}
