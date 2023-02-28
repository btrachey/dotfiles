local function get_file_content(filepath, ignore_string)
  local handle = assert(io.open(filepath, "rb"))
  local content = handle:read("*a")
  handle:close()
  if content == ignore_string then
    return ""
  else
    return content
  end
end

-- custom calendar widget
local next_calendar_event = function()
  return get_file_content(vim.env.HOME .. "/.minutes_to_next_event", "None")
end
local calendar_component = { next_calendar_event, icon = '' }

-- custom email widget
local unread_emails = function()
  return get_file_content(vim.env.HOME .. "/.new_emails_count", "0")
end
local mail_component = { unread_emails, icon = '黎' }

local setup = function()
  require("lualine").setup({
    options = {
      theme = "auto",
      ignore_focus = { "tvp" },
    },
    sections = {
      lualine_a = { "mode" }, -- default
      -- lualine_a = { "mode", { "filename", cond = function() return vim.fn.tabpagenr("$") == 1 end }, { "tabs", mode = 1, cond = function() return vim.fn.tabpagenr("$") > 1 end } },
      lualine_b = { "branch", "diff", "diagnostics" }, -- default
      -- lualine_c = { "filename", "g:metals_status", require("dap").status }, -- default
      lualine_c = { { "filename", cond = function() return vim.fn.tabpagenr("$") == 1 end },
        { "tabs", mode = 1, cond = function() return vim.fn.tabpagenr("$") > 1 end }, "g:metals_status",
        require("dap").status },
      -- lualine_x = { "encoding", "fileformat", "filetype" }, -- default
      lualine_x = { "filetype" },
      -- lualine_y = { "progress" }, -- default
      lualine_y = { "progress", "location" },
      -- lualine_z = { "location" }, -- default
      lualine_z = { mail_component, calendar_component },
    },
    tabline = {
      -- lualine_a = { { 'tabs', mode = 1, cond = function() return vim.fn.tabpagenr("$") > 1 end} },
      -- lualine_z = { mail_component, calendar_component }
    },
    extensions = { "nvim-dap-ui", "fugitive", "quickfix" }
  })
end

return {
  setup = setup,
}
