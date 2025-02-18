local wezterm = require("wezterm")
local util = require("util")

local act = wezterm.action
local module = {}

function module.apply_to_config(config)
  -- splits
  util.add_keys(config, {
    { key = "|", mods = "LEADER", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "-", mods = "LEADER", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane { confirm = false } },
    { key = "X", mods = "LEADER", action = act.CloseCurrentTab { confirm = false } },
    { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
    { key = "s", mods = "LEADER", action = act.ShowLauncherArgs { flags = "WORKSPACES" } },
    { key = "d", mods = "LEADER", action = act.SwitchToWorkspace { name = "default" } },
    {
      key = "n",
      mods = "LEADER",
      action = act.PromptInputLine({
        description = wezterm.format({
          { Text = "New workspace name: " }
        }),
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({ name = line, }), pane
            )
          end
        end)
      })
    },
  })
  -- navigation across panes
  local function is_vim(pane)
    local process_name = string.gsub(pane:get_foreground_process_name(), '(.*[/\\])(.*)', '%2')
    -- return process_name == 'nvim' or process_name == 'vim'
    return pane:get_user_vars().IS_NVIM == "true" or
        process_name == 'nvim' or process_name == 'vim'
  end
  local direction_keys = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right"
  }
  local nav_type_mod_map = {
    resize = "META",
    move = "CTRL"
  }

  local function split_nav(nav_type, key)
    local nav_type_mod = nav_type_mod_map[nav_type]
    return {
      key = key,
      mods = nav_type_mod,
      action = wezterm.action_callback(function(win, pane)
        if is_vim(pane) then
          -- pass the keys through to vim
          win:perform_action({
            SendKey = { key = key, mods = nav_type_mod, },
          }, pane)
        else
          if nav_type == "resize" then
            win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
          else
            win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
          end
        end
      end)
    }
  end

  util.add_keys(config, {
    split_nav("move", "h"),
    split_nav("move", "j"),
    split_nav("move", "k"),
    split_nav("move", "l"),
    split_nav("resize", "h"),
    split_nav("resize", "j"),
    split_nav("resize", "k"),
    split_nav("resize", "l"),
  })

  -- navigate to tabs
  local function map_tab_keys(i)
    return {
      key = tostring(i),
      mods = "LEADER",
      action = act.ActivateTab(i - 1)
    }
  end
  local mappings = {}
  for i = 1, 8 do
    table.insert(mappings, map_tab_keys(i))
  end
  util.add_keys(config, mappings)
end

return module
