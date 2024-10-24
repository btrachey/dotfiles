require("btrachey.snippets.std_imports")

local snips = {
  s({ trig = "main", desc = "Main method" },
    fmta(
      [[
        if __name__ == "__main__":
            <>
      ]], { i(0) })
  ),
}
local auto_snips = {}
return snips, auto_snips
