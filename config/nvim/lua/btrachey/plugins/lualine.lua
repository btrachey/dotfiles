-- https://github.com/nvim-lualine/lualine.nvim
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto",
      ignore_focus = { "tvp" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diagnostics" },
      lualine_c = {
        {
          "filename",
          cond = function()
            return vim.fn.tabpagenr("$") == 1
          end,
        },
        -- {
        --   "tabs",
        --   mode = 1,
        --   cond = function()
        --     return vim.fn.tabpagenr("$") > 1
        --   end,
        -- },
        {
          -- metals build server
          function()
            local bsp = vim.g["metals_bsp_status"]
            return (string.len(bsp) > 0) and bsp or ""
          end,
        },
        require("dap").status,
      },
      lualine_x = { "filetype" },
      lualine_y = { "progress", "location" },
      lualine_z = { "searchcount" },
    },
    extensions = {
      "fugitive",
      "fzf",
      "lazy",
      "man",
      "mason",
      "nvim-dap-ui",
      "oil",
      "quickfix",
    },
  },
}
