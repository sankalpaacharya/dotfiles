on run argv
	if argv is {} then
		set target to application id (run script "ObjC.import('CoreServices'); ObjC.castRefToObject($.LSCopyDefaultHandlerForURLScheme($('https'))).js" in "JavaScript")
	else
		set target to application (item 1 of argv)
	end if
	ignoring application responses
		tell target
			reopen
			activate
		end tell
	end ignoring
end run
