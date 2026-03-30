require("btrachey.snippets.std_imports")

local snips = {
  -- s(
  --   { trig = "main", desc = "Main method" },
  --   fmta(
  --     [[
  --       def main(args: Array[String]): Unit = {
  --         <>
  --       }
  --     ]],
  --     { i(0) }
  --   )
  -- ),
}

local auto_snips = {
  s(
    {
      trig = [[\beg]],
      desc = "begin/end zone",
    },
    fmta(
      [[
  \begin{<>}
    <>
  \end{<>}
  ]],
      { i(1), i(0), rep(1) }
    )
  ),
}

return snips, auto_snips
