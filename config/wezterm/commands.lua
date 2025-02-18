local wezterm = require("wezterm")
local util = require("util")

local act = wezterm.action
local module = {}

function module.apply_to_config(config)
  util.add_keys(config, {
    {
      key = "q",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        local windows = wezterm.mux.all_windows()
        for i = 1, #windows, 1 do
          local w = windows[i]
          wezterm.log_info(w:window_id())
          wezterm.log_info(w:get_workspace())
        end
      end
      )
    },
    {
      key = "p",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane)
        local _, scala_projects, _ = wezterm.run_child_process { wezterm.home_dir .. "/.dotfiles/path_scripts/find-scala-projects", "scala" }
        local scala_project_paths = {}
        for s in scala_projects:gmatch("[^\r\n]+") do
          table.insert(scala_project_paths, s)
        end
        local choices = {}
        for _, path in ipairs(scala_project_paths) do
          table.insert(choices, { label = "(Scala) " .. path, id = wezterm.json_encode({ type = "scala", path = path }) })
        end
        window:perform_action(
          act.InputSelector {
            action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
              if not id and not label then
                wezterm.log_info("cancelled")
              else
                local parsed_id = wezterm.json_parse(id)
                local proj_dir = util.last(util.split(parsed_id.path, "/"))
                local proj_type = parsed_id.type
                wezterm.log_info("opening project `" .. proj_dir .. "` (" .. proj_type .. ")")
                inner_window:perform_action(
                  act.SwitchToWorkspace {
                    name = proj_dir,
                    spawn = {
                      cwd = parsed_id.path,
                    }
                  },
                  inner_pane
                )
                local windows = wezterm.mux.all_windows()
                for i = 1, #windows, 1 do
                  local w = windows[i]
                  local w_workspace = w:get_workspace()
                  wezterm.log_info("proj_dir " .. proj_dir)
                  wezterm.log_info("w_workspace " .. w_workspace)
                  if w_workspace == proj_dir then
                    local gui_window = w:gui_window()
                    gui_window:perform_action(
                      act.SendString("e build.*\n"),
                      w:active_pane()
                    )
                    gui_window:perform_action(
                      act.SpawnTab("CurrentPaneDomain"),
                      w:active_pane()
                    )
                    gui_window:perform_action(
                      act.SendString("sc\n"),
                      w:active_pane()
                    )
                    gui_window:perform_action(
                      act.SplitHorizontal,
                      w:active_pane()
                    )
                    gui_window:perform_action(
                      act.ActivateTab(0),
                      w:active_pane()
                    )
                  end
                end
              end
            end),
            title = "Projects",
            choices = choices,
            alphabet = "123456789",
            description = "Choose a number or press / to search."
          },
          pane
        )
      end
      )
    }
  }
  )
end

return module
