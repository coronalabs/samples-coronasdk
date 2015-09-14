-- Abstract: Timer sample app, also demonstrating a table listener
-- 
-- Author: Corona Labs
--
-- Demonstrates: 
-- 		Demonstrates use of the timer.performWithDelay,
--		timer.pause, timer.resume, timer.cancel
--
-- File dependencies: none
--
-- Target devices: Simulator, iOS and Android
--
-- Limitations: None
--
-- Update History:
--	v1.1		7/26/2011	Working version
--	v1.2		11/28/2011	Added timer.pause, timer.resume, and timer.cancel (build 594)
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local widget = require( "widget" )

local timeDelay = 500		-- Timer value

local button1, button2, timerID	-- forward references

local runMode = true	-- for Pause/Resume button state
local started = true
local text = ""

local background = display.newImage( "color_blur.png", display.contentCenterX, display.contentCenterY )

------------------------------------------------------------
-- printd( msg )
--
-- Displays msg on display and advances display pointer
------------------------------------------------------------

local dY = 40	-- starting location

function printd( msg )
		print( "printd -> " .. msg )
        local txt = display.newText(msg == nil and "nil" or " " .. msg, 0, dY, native.systemFont, 13)
        txt.anchorX = 0.0	-- align object to left-center
        dY = dY + 20
end

-- Toggle between Pause and Resume
local buttonHandler1 = function( event )

	local result
	
	if runMode then
		button1:setLabel( "Resume" )
		runMode = false
		result = timer.pause( timerID )
		printd( "Pause: " .. result )
	else
		button1:setLabel( "Pause" )
		runMode = true
		result = timer.resume( timerID )
		printd( "Resume: " .. result )
	end
	
	if started == false then
		button1:setLabel( "Pause" )
		runMode = true
		text.text = "0"
		timerID = timer.performWithDelay( timeDelay, text, 50 )
		printd( "Resume: " .. result )
		started = true
	end
end

-- Cancel timer
local buttonHandler2 = function( event )

	local result, result1
	
	result, result1 = timer.cancel( timerID )
	button1:setLabel( "Start" )
	started = false
	text.text = "0"
	
	printd( "Cancel: " .. tostring(result) ..", " .. tostring(result1) )

end

button1 = widget.newButton
{
	id = "button1",
	defaultFile = "buttonBlue_100.png",
	overFile = "buttonBlueOver_100.png",
	label = "Pause",
	font = native.systemFontBold,
	fontSize = 22,
	emboss = true,
	onRelease = buttonHandler1,
}

button2 = widget.newButton
{
	id = "button2",
	defaultFile = "buttonBlue_100.png",
	overFile = "buttonBlueOver_100.png",
	label = "Cancel",
	font = native.systemFontBold,
	fontSize = 22,
	emboss = true,
	onRelease = buttonHandler2,
}
button1.x = display.contentCenterX; button1.y = 360
button2.x = display.contentCenterX; button2.y = 430

text = display.newText( "0", display.contentCenterX, 105, native.systemFontBold, 160 )
text:setFillColor( 0, 0, 0 )

function text:timer( event )
	
	local count = event.count

	print( "Table listener called " .. count .. " time(s)" )
	self.text = count

	if count >= 20 then
		timer.cancel( event.source ) -- after the 20th iteration, cancel timer
	end
end

-- Register to call t's timer method 50 times
timerID = timer.performWithDelay( timeDelay, text, 50 )

print( "timerID = " .. tostring( timerID ) )
