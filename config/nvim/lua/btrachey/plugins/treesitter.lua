-- vim.api.nvim_create_autocmd("FileType", { -- enable treesitter highlighting and indents
--   callback = function(args)
--     local filetype = args.match
--     local lang = vim.treesitter.language.get_lang(filetype)
--     if vim.treesitter.language.add(lang) then
--       vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
--       vim.treesitter.start()
--     end
--   end
-- })
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    -- treesitter text objects; https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
      opts = {
        set_jumps = true,
      },
      keys = {
        {
          "aa",
          function()
            require("nvim-treesitter-textobjects.select").select_textobject(
              "@parameter.outer",
              "textobjects"
            )
          end,
          mode = { "x", "o" },
          desc = "parameter",
        },
        {
          "ia",
          function()
            require("nvim-treesitter-textobjects.select").select_textobject(
              "@parameter.inner",
              "textobjects"
            )
          end,
          mode = { "x", "o" },
          desc = "parameter",
        },
        {
          "[c",
          function()
            require("nvim-treesitter-textobjects.move").goto_previous_start(
              "@comment.outer",
              "textobjects"
            )
          end,
          mode = { "n", "x", "o" },
        },
        {
          "]c",
          function()
            require("nvim-treesitter-textobjects.move").goto_next_start(
              "@comment.outer",
              "textobjects"
            )
          end,
          mode = { "n", "x", "o" },
        },
      },
    },
    -- tree-sitter context https://github.com/nvim-treesitter/nvim-treesitter-context
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = {
        max_lines = 3,
        multiline_threshold = 1,
        min_window_height = 20,
        line_numbers = true,
        separator = "─",
      },
    },
  },
  init = function()
    vim.api.nvim_create_autocmd({ "BufRead" }, {
      callback = function(opts)
        local filetype = vim.bo[opts.buf].filetype
        local ignore_types = { "oil", "qf", "sbt" }
        vim.schedule(function()
          for _, ignore_type in ipairs(ignore_types) do
            if filetype == ignore_type then
              return
            end
          end
          local nts = require("nvim-treesitter")
          nts.install(filetype)
        end)
      end,
      group = vim.api.nvim_create_augroup("treesitter_group", { clear = true }),
    })
  end,
}
