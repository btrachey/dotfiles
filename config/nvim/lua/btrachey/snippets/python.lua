require("btrachey.snippets.std_imports")

local snips = {
  s(
    { trig = "main", desc = "main method" },
    fmta(
      [[
        if __name__ == "__main__":
            <>
      ]],
      { i(0) }
    )
  ),
  s(
    { trig = "def", desc = "function definition" },
    fmta(
      [[
        def <>(<>):
          <>
      ]],
      { i(1), i(2), i(0) }
    )
  ),
}
local auto_snips = {}
return snips, auto_snips
