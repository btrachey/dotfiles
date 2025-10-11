local wezterm = require("wezterm")
local util = require("util")
local act = wezterm.action
local module = {}

function module.apply_to_config(config)
  config.color_scheme = "rose-pine"
  config.colors = {
    selection_fg = "none",
    selection_bg = "rgba(50% 50% 50% 20%)"
  }
  config.font = wezterm.font({
    family = "FiraCode Nerd Font",
    -- see https://github.com/tonsky/FiraCode/wiki/How-to-enable-stylistic-sets
    harfbuzz_features = { "cv13", "cv30", "cv25", "cv26", }
  })
  config.font_size = 13
  config.window_decorations = "RESIZE"
  config.animation_fps = 1
  config.cursor_blink_rate = 600
  -- config.window_frame = {
  --   font = wezterm.font({
  --     family = "FiraCode Nerd Font",
  --     weight = "Bold"
  --   }),
  --   font_size = 13,
  -- }
  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = true

  -- change tab separator
  local divider = wezterm.nerdfonts.cod_kebab_vertical
  -- local divider = "|"
  local function tab_title(tab_info)
    local title = tab_info.tab_title
    if title and #title > 0 then
      return title
    end
    return tab_info.active_pane.title
  end
  wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
    local color_scheme = config
    for k, v in ipairs(color_scheme) do
      wezterm.log_info("key" .. tostring(k))
      wezterm.log_info("value" .. tostring(v))
    end
    local title = tab_title(tab)
    local title_with_index = tab.tab_index + 1 .. " " .. title
    if tab.is_active then
      return {
        { Text = divider .. " " .. title_with_index .. " " .. divider }
      }
    end
    return " " .. title_with_index .. " "
  end)

  -- key_table for resizing panes
  local function resize_pane(key, direction)
    return {
      key = key,
      action = act.AdjustPaneSize { direction, 3 }
    }
  end
  util.add_keys(config, {
    {
      key = "r",
      mods = "LEADER",
      action = act.ActivateKeyTable {
        name = "resize_panes",
        one_shot = false,
        timeout_milliseconds = 1000
      }
    }
  })
  util.add_key_table(config, {
    resize_panes = {
      resize_pane("h", "Left"),
      resize_pane("j", "Down"),
      resize_pane("k", "Up"),
      resize_pane("l", "Right"),
    }
  })

  -- name of Session/Workspace to the left of all tabs
  wezterm.on("update-right-status", function(window, pane)
    window:set_left_status(wezterm.format {
      { Text = " " .. window:active_workspace() .. " " }
    })
  end)
end

return module
