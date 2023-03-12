on collectAudioOutputs()
	tell application "System Events"
		tell application process "System Preferences"
			tell tab group 1 of window "Sound"
				click radio button "Output"
				tell table 1 of scroll area 1
					set outputsList to {}
					repeat with i from 1 to (count of rows)
						
						set end of outputsList to ((value of text field of row i as string) & "," & i as string) & "," & selected of row i as string
					end repeat
				end tell
			end tell
		end tell
	end tell
	return outputsList
end collectAudioOutputs

on switchToOutput(outputOptions, desiredOutputName)
	set d to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ","
	repeat with i from 1 to (count of outputOptions)
		
		set outputName to item 1 of text items of item i of outputOptions
		set outputIdx to item 2 of text items of item i of outputOptions as integer
		set outputSelected to item 3 of text items of item i of outputOptions as boolean
		--log "Output name: " & outputName
		--log "Output index: " & outputIdx
		ignoring case
			if (outputName contains desiredOutputName) then
				--log "Desired output name: " & outputName
				--log "Desired output index: " & outputIdx
				tell application "System Events"
					tell application process "System Preferences"
						tell tab group 1 of window "Sound"
							click radio button "Output"
							set selected of row outputIdx of table 1 of scroll area 1 to true
						end tell
					end tell
				end tell
			end if
		end ignoring
		
	end repeat
	set AppleScript's text item delimiters to d
end switchToOutput

on currentSelection(outputOptions)
	set current to ""
	set d to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ","
	repeat with i from 1 to (count of outputOptions)
		set outputName to item 1 of text items of item i of outputOptions
		set outputIdx to item 2 of text items of item i of outputOptions as integer
		set outputSelected to item 3 of text items of item i of outputOptions as boolean
		if outputSelected then set current to outputName
	end repeat
	set AppleScript's text item delimiters to d
	return current
end currentSelection

on logOptions(outputOptions)
	set d to AppleScript's text item delimiters
	set AppleScript's text item delimiters to ","
	repeat with i from 1 to (count of outputOptions)
		set outputName to item 1 of text items of item i of outputOptions
		set outputIdx to item 2 of text items of item i of outputOptions as integer
		set outputSelected to item 3 of text items of item i of outputOptions as boolean
		log outputName & return
	end repeat
	set AppleScript's text item delimiters to d
end logOptions

on run argv
	-- if no target output given, toggle
	if (count of argv) is 0 then
		set desiredAudioOutput to "toggle"
	else
		set desiredAudioOutput to item 1 of argv
		--set desiredAudioOutput to "sony"
	end if
	
	-- activate system prefs
	tell application "System Preferences"
		set current pane to pane "com.apple.preference.sound"
	end tell
	
	-- wait for "sound" tab to open
	tell application "System Events"
		tell application process "System Preferences"
			repeat until exists tab group 1 of window "Sound"
			end repeat
		end tell
	end tell
	
	-- collect list of output names and indices 
	set audioOutputs to collectAudioOutputs()
	--log audioOutputs
	
	-- get currently selected output
	set currentlySelected to currentSelection(audioOutputs)
	
	-- if toggle, determine what to toggle to
	set toggleOptions to {"shokz", "built-in"}
	ignoring case
		if (desiredAudioOutput is equal to "toggle" and currentlySelected contains item 1 of toggleOptions) then
			set desiredAudioOutput to "built-in"
		else if (desiredAudioOutput is equal to "toggle" and currentlySelected contains item 2 of toggleOptions) then
			set desiredAudioOutput to "shokz"
		else if (desiredAudioOutput is equal to "list") then
			logOptions(audioOutputs)
		end if
	end ignoring
	
	-- make the switch
	switchToOutput(audioOutputs, desiredAudioOutput)
	
	-- quit system prefs so it doesn't clutter the screen
	tell application "System Preferences"
		quit
	end tell
end run