local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
  local default_rules = wezterm.default_hyperlink_rules()

  -- make JIRA issues clickable
  -- also match when there is no dash and just a space between the project key and the issue number,
  -- so capture project key in $1 and issue number in $2 then re-construct into the url
  local work_url
  if os.getenv("WORK_JIRA_URL") then
    work_url = os.getenv("WORK_JIRA_URL")
  else
    work_url = "FOO"
  end
  table.insert(default_rules, {
    regex = [[\b([A-Za-z]{3,})[-|\s](\d+)\b]],
    format = "https://" .. work_url .. ".atlassian.net/browse/$1-$2",
  })
  -- make username/project paths clickable. this implies paths like the following are for github:
  -- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
  -- as long as a full url hyperlink regex exists before this in the config, it should not match a full url to
  -- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
  table.insert(default_rules, {
    regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
    format = "https://www.github.com/$1/$3",
  })

  config.hyperlink_rules = default_rules
end

return module
