require("btrachey.snippets.std_imports")

return {
  -- regular snippets
}, {
  -- auto snippets
  s("#!", t("#!/usr/bin/env zsh")),
  s(
    "if",
    fmta(
      [[
      if <>; then
        <>
      fi
    ]],
      { i(1), i(2) }
    )
  ),
  s(
    "elif",
    fmta(
      [[
      elif <>; then
        <>
    ]],
      { i(1), i(2) }
    )
  ),
  s(
    "else",
    fmta(
      [[
      else
        <>
    ]],
      { i(1) }
    )
  ),
}
