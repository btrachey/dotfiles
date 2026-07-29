#!/usr/bin/env osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title LazyJira
# @raycast.mode silent

# Optional parameters:
# @raycast.icon ☑️ 
# @raycast.packageName LazyJira

# Documentation:
# @raycast.description Open LazyJira
# @raycast.author btrachey
# @raycast.authorURL https://raycast.com/btrachey

try
	-- Check if WezTerm is running
	set weztermRunning to false
	tell application "System Events"
		if (name of processes) contains "wezterm-gui" then
			set weztermRunning to true
		end if
	end tell
	
	-- Launch WezTerm if not running...
	if not weztermRunning then
		tell application "WezTerm" to launch
		-- Wait a moment for WezTerm to fully and completely launch
		delay 2
	end if
	
	-- Activate WezTerm (Open a dialog)
	tell application "WezTerm" to activate
	
	-- Create new terminal session
	try
		do shell script "/Applications/WezTerm.app/Contents/MacOS/wezterm cli spawn -- zsh -i -c lazyjira"
		do shell script "/Applications/WezTerm.app/Contents/MacOS/wezterm cli set-tab-title lazyjira"
	on error errMsg
		display dialog "Failed to create new WezTerm session: " & errMsg buttons {"OK"} default button "OK"
		return
	end try

on error errMsg
	display dialog "WezTerm Alfred Script Error: " & errMsg buttons {"OK"} default button "OK"
end try
