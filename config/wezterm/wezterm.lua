local wezterm = require("wezterm")
-- local modules
local util = require("util")
local appearance = require("appearance")
local multiplexing = require("multiplexing")
local hyperlinks = require("hyperlinks")
local commands = require("commands")

local act = wezterm.action
local config = wezterm.config_builder()

config.term = "wezterm"
config.audible_bell = "Disabled"
config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }

appearance.apply_to_config(config)
multiplexing.apply_to_config(config)
hyperlinks.apply_to_config(config)
commands.apply_to_config(config)

-- must be used with shell integration - `$HOME/.wezterm.sh`
util.add_keys(config, {
  { key = "UpArrow",   mods = "SHIFT", action = act.ScrollToPrompt(-1) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action_callback(function(win, pane, line)
      wezterm.log_info(pane:get_semantic_zones())
    end)
  },
})

return config
