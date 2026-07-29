-- https://github.com/nvim-lualine/lualine.nvim
return {
  "nvim-lualine/lualine.nvim",
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    options = {
      theme = "auto",
      ignore_focus = { "tvp" },
    },
    sections = {
      lualine_a = {},
      -- lualine_a = { "mode" },
      lualine_b = { "branch", "diagnostics" },
      lualine_c = {
        {
          "filename",
          cond = function()
            return vim.fn.tabpagenr("$") == 1
          end,
        },
        {
          -- metals build server
          function()
            local bsp = vim.g["metals_bsp_status"]
            return (string.len(bsp) > 0) and bsp or ""
          end,
        },
      },
      lualine_x = {
        "filetype",
        {
          -- show kulala env
          function()
            if vim.bo.filetype == "http" or vim.bo.filetype == "rest" then
              return require("kulala").get_selected_env()
            else
              return ""
            end
          end,
        },
      },
      lualine_y = { "progress", "location" },
      lualine_z = { "searchcount" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "vim.api.nvim_buf_get_name(0)" },
      -- lualine_c = { "filename" },
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
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
