require("btrachey.snippets.std_imports")

---create a postfix snippet filled in with the provided trigger, prefix, and punctuation
local makeTypeSnippet = function(triggerString, config)
  local surroundType = {
    ["paren"] = { ["open"] = "(", ["close"] = ")" },
    ["bracket"] = { ["open"] = "[", ["close"] = "]" }
  }
  return postfix(triggerString, {
    f(function(_, parent)
      local pMatch = parent.snippet.env.POSTFIX_MATCH
      if pMatch:sub(1, 1):match("%u") then
        local surround = surroundType[config["punct"]]
        return config["name"] .. surround["open"] .. parent.snippet.env.POSTFIX_MATCH .. surround["close"]
      else
        return pMatch .. triggerString
      end
    end, {}),
  })
end

local typesToSnippet = {
  [".eit"] = { ["name"] = "Either", ["punct"] = "bracket" },
  [".opt"] = { ["name"] = "Option", ["punct"] = "bracket" },
  [".seq"] = { ["name"] = "Seq", ["punct"] = "bracket" },
}

local makeFuncSnippet = function(triggerString, config)
  local surroundType = {
    ["paren"] = { ["open"] = "(", ["close"] = ")" },
    ["bracket"] = { ["open"] = "[", ["close"] = "]" }
  }
  return postfix(triggerString, {
    f(function(_, parent)
      -- local pMatch = parent.snippet.env.POSTFIX_MATCH
      -- if pMatch:sub(1, 1):match("%u") then
      local surround = surroundType[config["punct"]]
      return config["name"] .. surround["open"] .. parent.snippet.env.POSTFIX_MATCH .. surround["close"]
      -- else
      --   return pMatch .. triggerString
      -- end
    end, {}),
  })
end

-- local funcsToSnippet = {
--   [".col"] = { ["name"] = "col", ["punct"] = "paren" }
-- }

local snips = {
  s({ trig = "main", desc = "Main method" },
    fmta(
      [[
        def main(args: Array[String]): Unit = {
          <>
        }
      ]],
      { i(0) }
    )
  ),
}

local auto_snips = {
  -- s({ trig = "([^.])opt", regTrig = true, wordTrig = false, desc = "Option[VISUAL]" },
  --   fmta(
  --     "<>Option[<>]",
  --     {
  --       f(function(_, snip) return snip.captures[1] end),
  --       d(1, get_visual)
  --     }
  --   )
  -- ),
}

for k, v in pairs(typesToSnippet) do
  table.insert(auto_snips, makeTypeSnippet(k, v))
end
-- for k, v in pairs(funcsToSnippet) do
--   table.insert(auto_snips, makeFuncSnippet(k, v))
-- end

return snips, auto_snips
