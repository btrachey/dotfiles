#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Open Argos-mySQL Connection
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🔍
# @raycast.packageName Argos
# @raycast.argument1 {"type":"dropdown","placeholder":"env","data":[{"title":"sandbox","value":"sandbox"},{"title":"dev","value":"dev"},{"title":"test","value":"test"},{"title":"prod","value":"prod"}]}

# Documentation:
# @raycast.description Open Argos-mySQL Connection
# @raycast.author btrachey
# @raycast.authorURL https://raycast.com/btrachey

tg mysql $1 --dev --open
