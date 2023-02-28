local setup = function()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "bash", "lua", "python", "scala", "hocon", "yaml", "sql", "dockerfile", "vim" },
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      -- additional_vim_regex_highlighting = true,
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        -- Automatically jump forward to next textobject
        lookahead = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Select outer part of function region" },
          ["if"] = { query = "@function.inner", desc = "Select inner part of function region" },
          ["ac"] = { query = "@comment.outer", desc = "Select comment region" },
          ["aa"] = { query = "@parameter.outer", desc = "Select outer part of parameter region" },
          ["ia"] = { query = "@parameter.inner", desc = "Select inner part of parameter region" },
        }
      },
      move = {
        enable = true,
        -- add these jumps to jumplist when used
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Goto start of next function" },
          ["]c"] = { query = "@comment.outer", desc = "Goto start of next comment" },
          ["]a"] = { query = "@parameter.outer", desc = "Goto start of next parameter" }
        },
        goto_next_end = {
          ["]F"] = { query = "@function.inner", desc = "Goto end of next function" },
          ["]C"] = { query = "@comment.inner", desc = "Goto end of next comment" },
          ["]A"] = { query = "@parameter.inner", desc = "Goto end of next parameter" }
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Goto start of next function" },
          ["[c"] = { query = "@comment.outer", desc = "Goto start of next comment" },
          ["[a"] = { query = "@parameter.outer", desc = "Goto start of next parameter" }
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.inner", desc = "Goto end of next function" },
          ["[C"] = { query = "@comment.inner", desc = "Goto end of next comment" },
          ["[A"] = { query = "@parameter.inner", desc = "Goto end of next parameter" }
        },
      },
      lsp_interop = {
        enable = true,
        border = 'none',
        peek_definition_code = {
          ["<leader>df"] = "@function.outer",
          ["<leader>dF"] = "@class.outer"
        }
      }
    }
  }
end

return {
  setup = setup,
}
