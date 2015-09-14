-- Project: SytemEvents
--
-- Date: August 19, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Abstract:	Display System and Orientation Events on the screen
--				Events are sent to the screen and console.
--				Uses auto rotation (build.settings) to rotate screen.
--
-- Demonstrates: 
-- 		Systemevents messages
--			applicationStart
-- 			applicationExit
--  		applicationSuspend
--  		applicationResume
--  	Orientation events
--  	Getting Screen Width and Height
--		Creating and detecting file in /Documents directory
--		Display simple text message for limited period of time
--
-- File dependencies: build.settings
--
-- Target devices: Simulator and iPad
--
-- Limitations: This version is customized to iPad for screen size and orientation
--
-- Update History: none
--
-- Comments:
--		A special file is store in the /Documents directory when the app is closed.
--		This file is read at start-up time to determine if the app received an
--		applicationExit event. A message is displayed if found and the file deleted.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX		-- find center of screen
local centerY = display.contentCenterY		-- find center of screen
	
io.output():setvbuf('no') 		-- **debug: disable output buffering for Xcode Console

display.setDefault( "background", 80/255 )

-- forward references
local eventTxt, eventLabel, OEventLabel
local previousEvent = nil

-----------------------------------------------------------
-- textMessage() --
-----------------------------------------------------------
-- v1.0
--
-- Create a message that is displayed for a few seconds.
-- Text is centered horizontally on the screen.
--
-- Enter:	str = text string
--			scrTime = time (in seconds) message stays on screen (0 = forever) -- defaults to 3 seconds
--			location = placement on the screen: "Top", "Middle", "Bottom" or number (y)
--			size = font size (defaults to 24)
--			color = font color (table) (defaults to white)
--
-- Returns:	text object (for removing or hiding later)
--
local textMessage = function( str, location, scrTime, size, color, font )

	local x, t
	
	size = tonumber(size) or 24
	color = color or {1, 1, 1}
	font = font or native.systemFont

	-- Determine where to position the text on the screen
	if "string" == type(location) then
		if "Top" == location then
			x = display.contentHeight/4
		elseif "Bottom" == location then
			x = (display.contentHeight/4)*3
		else
			-- Assume middle location
			x = display.contentHeight/2
		end
	else
		-- Assume it's a number -- default to Middle if not
		x = tonumber(location) or display.contentHeight/2
	end
	
	scrTime = (tonumber(scrTime) or 3) * 1000		-- default to 3 seconds (3000) if no time given

	t = display.newText(str, 0, 0, font, size )
	t.x = display.contentWidth/2
	t.y = x
	t:setFillColor( color[1], color[2], color[3] )
	
	-- Time of 0 = keeps on screen forever (unless removed by calling routine)
	--
	if scrTime ~= 0 then
	
		-- Function called after screen delay to fade out and remove text message object
		local textMsgTimerEnd = function()
			transition.to( t, {time = 500, alpha = 0}, 
				function() t.removeSelf() end )
		end
	
		-- Keep the message on the screen for the specified time delay
		timer.performWithDelay( scrTime, textMsgTimerEnd )
	end
	
	return t		-- return our text object in case it's needed
	
end	-- textMessage()
-----------------------------------------------------------

-- The following file is created when the app receives an applicationExit event.
-- The file is used to determine if the app received the event the last time it was run.
--
local filePath = system.pathForFile( "ExitState.txt", system.DocumentsDirectory )

-- Check if ExitFile exists
--
-- Returns true if it exists 
-- The file is deleted if it exists
--
function isExitFile()
	local results = false
	
	-- io.open opens a file at filePath. returns nil if no file found
	local file = io.open( filePath, "r" )
	
--	print( filePath )
	
	if file then
		io.close( file )
		os.remove( filePath )	-- delete the file
		results = true
	end

	return results
end

-- Create the ExitFile
--
function createExitFile()
    -- create the ExitState file
--  print( "Creating file..." )
    file = io.open( filePath, "w" )
	io.close( file )
end

-----------------------------------------------------------------------
-- Come here on System Events
-- Display the System Message on the screen
--
-- Creates an ExitFile.txt file when Exit event found
-- (the file is used to indicate that the Exit event was found the
--  last time the app was run.
--
-- The file existence is checked during any other event.
-----------------------------------------------------------------------
--
function onSystemEvent( event ) 
	print (event.name .. ", " .. event.type)
	print ("Previous event type: " .. tostring(previousEvent))
	print()

	if  "applicationExit" == event.type then
		-- Create the unique file before exiting
		createExitFile()
	elseif "applicationOpen" == event.type then
		native.showAlert( "Open via custom url", event.url, { "OK" } )
	else
		-- For all other events, check to see if file exist
		if isExitFile() then
			print ("Found ExitState.txt from last Run!")
			-- str, location, scrTime, size, color, font
			textMessage( "App Did Exit After Last Run!", 160, 3, 16, {255, 0, 255} )
		end
		
	end

	-- Display the previous event
	-- (This may have occurred during a suspend event)
	--
	if not pEventLabel then
		pEventLabel = display.newText( "x", centerX, centerY+30, nil, 18 )
		pEventLabel:setFillColor( 1, 1, 0 )
	end
	
	pEventLabel.text = "(Previous: " .. tostring(previousEvent) .. ")"
		


	-- Display the system message on the screen
	if not eventLabel then
		eventLabel = display.newText( "x", centerX, centerY, nil, 20 )
		eventLabel:setFillColor( 1, 1, 0 )
	end

	eventLabel.text = event.type
	
	previousEvent = event.type		-- save the state for next time
	
	return true
	
end

-----------------------------------------------------------------------
-- Come here on Orientation Events
-- Display the Orientation Message on the screen
-----------------------------------------------------------------------
--
function onOrientationEvent( event ) 
	
	centerX = display.contentCenterX		-- find new center of screen
	centerY = display.contentCenterY		-- find new center of screen

	print ("onOrientationEvent: " .. event.name .. ", " .. event.type)
		
	-- Display the Orientation message on the screen
	if not OEventLabel then
		OEventLabel = display.newText("x", centerX, 100, nil, 20 )
		OEventLabel:setFillColor( 1, 1, 0 )
	end
	 
	OEventLabel.text = event.type
	
	-- Display the Width and Height of the screen
	if not WHLabel then
		WHLabel = display.newText("x", centerX, 130, nil, 16 )
		WHLabel:setFillColor( 1, 1, 1 )
	end
	 
	WHLabel.text = "Width: " .. display.contentWidth .. ", Height: " .. display.contentHeight
	
	-- Since our orientation changed, center the text on the screen
	pEventLabel.x = centerX
	OEventLabel.x = centerX
	eventLabel.x = centerX
	eventTxt.x = centerX
	WHLabel.x = centerX	
	title.x = centerX	

	return true
	
end

-----------------------------------------------------------------------
-- Create text message label
--
eventTxt = display.newText( "Last Callback Event:", centerX, centerY-30, nil, 20 )
eventTxt:setFillColor( 1, 1, 1 )

title = textMessage( "** SystemEvents **", 40, 0, 24, {1, 1, 1} )	-- str, location, scrTime, size, color, font

-- Add the System callback event
Runtime:addEventListener( "system", onSystemEvent );

-- Add the Orientation callback event
Runtime:addEventListener( "orientation", onOrientationEvent );
