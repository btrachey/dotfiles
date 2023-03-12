on run argv
	-- require a zoom link argument to run
--		if (count of argv) is 0 then return
	
	set idleTime to do shell script "ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print $NF/1000000000; exit}'"
	
	-- if user has been idle for more than 30 seconds, do not auto-open
	if (idleTime > 30) then
		display dialog "Skipping auto-open" giving up after 30
		return
	end if
	
	-- give the user the chance to stop the auto-open
	set response to (display dialog "Automatically opening the meeting in 5 seconds" buttons ["Stop"] with title "Zoom Opening" giving up after 5)
	if (button returned of response = "Stop") then
		return
	else
		--	open location "{html.escape(zoom_link)}"
		 -- open location item 1 of argv
		open location "zoommtg://protenus.zoom.us/join?action=join&confno=95036502808&pwd=cWd2S1lKOHVObUJiemxLajJpZURzZz09"
	end if
end run
