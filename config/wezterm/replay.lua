local wezterm = require("wezterm")
local util = require("util")

local act = wezterm.action
local module = {}

function module.apply_to_config(config)
  local extractor_funcs = {
    {
      prefix = nil,
      postfix = nil,
      func = function(s)
        local match = string.match(s, "`(.*)`")
        return match
      end,
    },
    {
      prefix = "open",
      postfix = nil,
      func = function(s)
        local hyperlink_regexes = {
          "%((%w+://%S+)%)",
          "%[(%w+://%S+)%]",
          "%{(%w+://%S+)%}",
          "%<(%w+://%S+)%>",
          "%w+://%S+",
        }
        for _, regex in ipairs(hyperlink_regexes) do
          local match = string.match(s, regex)
          if match and #match > 0 then
            wezterm.log_info(match)
            return string.gsub(match, "[\n\r]", "")
          end
        end
      end,
    },
  }
  local command_choices = function(pane, extractors)
    local choices = {}
    local zones = pane:get_semantic_zones()
    local last_output_zone = util.last_by(zones, function(e)
      return e["semantic_type"] == "Output"
    end)
    local last_output = pane:get_text_from_semantic_zone(last_output_zone)
    wezterm.log_info("last Output: " .. last_output)
    for _, extractor in ipairs(extractors) do
      local extracted = extractor.func(last_output)
      if extracted then
        table.insert(choices, {
          label = "`" .. extracted .. "`",
          id = wezterm.json_encode({
            command = extracted,
            prefix = extractor.prefix,
            postfix = extractor.postfix,
          }),
        })
      end
    end
    return choices
  end
  local send_command_string = function(command_id, pane)
    local parsed_id = wezterm.json_parse(command_id)
    wezterm.log_info("writing command to pane")
    wezterm.log_warn(parsed_id)
    pane:send_text(wezterm.shell_join_args({
      parsed_id.prefix,
      parsed_id.command,
      parsed_id.postfix,
    }))
  end
  util.add_keys(config, {
    -- get actionable commands out of the last output
    {
      key = "l",
      mods = "LEADER",
      action = wezterm.action_callback(function(window, pane, _, _)
        local extracted_commands = command_choices(pane, extractor_funcs)
        if #extracted_commands == 0 then
          wezterm.log_info("no commands found")
        elseif #extracted_commands == 1 then
          send_command_string(extracted_commands[1].id, pane)
        else
          window:perform_action(
            act.InputSelector({
              action = wezterm.action_callback(
                function(_, inner_pane, inner_id, inner_label)
                  if not inner_id and not inner_label then
                    wezterm.log_info("cancelled")
                  else
                    send_command_string(inner_id, inner_pane)
                  end
                end
              ),
              title = "Replay Command",
              choices = extracted_commands,
              alphabet = "123456789",
              description = "Send command to pane; press / to search.",
            }),
            pane
          )
        end
      end),
    },
  })
end

return module
