-- Abstract: Timer sample app, also demonstrating a table listener
--
-- Author: Corona Labs
--
-- Demonstrates:
--              Demonstrates use of the timer.performWithDelay,
--              timer.pause, timer.resume, timer.cancel,
--              synchronizing timers with wallclock time
--
-- File dependencies: none
--
-- Target devices: Simulator and all target platforms
--
-- Limitations: None
--
-- Update History:
--      v1.1            7/26/2011       Working version
--      v1.2            11/28/2011      Added timer.pause, timer.resume, and timer.cancel (build 594)
--      v2.0            03/03/2016      Updated sample
--
-- Comments:
--
-- Sample code is MIT licensed, see https://coronalabs.com/links/code/license
-- Copyright (C) 2016 Corona Labs Inc. All Rights Reserved.
--
---------------------------------------------------------------------------------------

if display.topStatusBarContentHeight > 0 then
	display.setStatusBar( display.HiddenStatusBar )
end

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Timer", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local worldGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

local widget = require( "widget" )

local timeDelay = 100		-- .1 second
local timerIterations = 600

local runMode = true	-- for Pause/Resume button state
local started = true
local startTime = 0
local pausedAt = 0

local text, button1, button2, timerID	-- forward references

local background = display.newImageRect( worldGroup, "Background.png", display.contentWidth, display.contentHeight - 50 )
background.x = display.contentCenterX
background.y = display.contentCenterY + 4

local function onOrientationChange( event )
	button1.x = display.contentCenterX
	button1.y = display.contentHeight - 100
	button2.x = display.contentCenterX
	button2.y = display.contentHeight - 50
	background.x = display.contentCenterX
	background.y = display.contentCenterY + 4
	background.height = display.contentHeight - 50
	text.x = display.contentCenterX
end

Runtime:addEventListener( "orientation", onOrientationChange )

-- Toggle between Pause and Resume
local buttonHandler1 = function( event )

	local result
	
	if runMode then
		button1:setLabel( "Resume" )
		runMode = false
		pausedAt = event.time
		result = timer.pause( timerID )
	elseif started then
		button1:setLabel( "Pause" )
		runMode = true
		result = timer.resume( timerID )
	end
	
	if started == false then
		button1:setLabel( "Pause" )
		runMode = true
		text.text = "0.0"
		timerID = timer.performWithDelay( timeDelay, text, timerIterations )
		started = true
		startTime = 0
		pausedAt = 0
	end
end

-- Cancel timer
local buttonHandler2 = function( event )

	local result, result1
	
	result, result1 = timer.cancel( timerID )
	button1:setLabel( "Start" )
	runMode = false
	started = false
	text.text = "0.0"
	startTime = 0
	pausedAt = 0
end

button1 = widget.newButton
{
	id = "button1",
	defaultFile = "buttonBlue_100.png",
	overFile = "buttonBlueOver_100.png",
	label = "Pause",
	labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	font = native.systemFontBold,
	fontSize = 20,
	emboss = true,
	onRelease = buttonHandler1,
}

button2 = widget.newButton
{
	id = "button2",
	defaultFile = "buttonBlue_100.png",
	overFile = "buttonBlueOver_100.png",
	label = "Cancel",
	labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	font = native.systemFontBold,
	fontSize = 20,
	emboss = true,
	onRelease = buttonHandler2,
}
button1.x = display.contentCenterX;
button1.y = display.contentHeight - 100
button2.x = display.contentCenterX;
button2.y = display.contentHeight - 50

-- In order for the right aligned timer to display nicely we need a font that
-- has monospaced digits.  Usually this is the system font and we can detect
-- that by measuring the relative widths of the '1' and '2' characters
local bestFontForDevice = nil
local testTextParams =
{
	x, y = -100,
	text = "1",
	font = native.systemFontBold,
	fontSize = 24,
}
local testText = display.newText( testTextParams )
local width1 = testText.width
testText.text = "2"
local width2 = testText.width
local platform = system.getInfo( "platformName" ):lower()

if width2 > width1 then
	-- system font doesn't have monospaced digits, use a font we know does
	bestFontForDevice = (platform == "win" and "Courier New" or "Helvetica Neue")
else
	-- the system font is our friend
	bestFontForDevice = native.systemFontBold
end

local textParams = 
{
    parent = worldGroup,
    text = "0.0",     
    x = display.contentCenterX,
    y = 105,
    width = display.contentWidth - 10,
    font = bestFontForDevice,
    fontSize = 150,
    align = "right"
}

-- the main timer display
text = display.newEmbossedText( textParams )
text:setFillColor( 0, 0, 0 )

function text:timer( event )
	
	local count = event.count
	if startTime == 0 then
		startTime = event.time
	end

	if pausedAt > 0 then
		startTime = startTime + (event.time - pausedAt)
		pausedAt = 0
	end

	-- print( "Timer listener called " .. count .. " time"..(count == 1 and "" or "s") )
	self.text = string.format("%.1f", (event.time - startTime)/1000)

	if (event.time - startTime) >= (timerIterations * timeDelay) then
		-- timer.cancel( event.source )
		print("Resetting timer")
		buttonHandler2()
		startTime = 0
	end

end

-- Register to call text's timer method timerIterations times
timerID = timer.performWithDelay( timeDelay, text, timerIterations )

print( "timerID = " .. tostring( timerID ) )

-- Silly animation using a timer
local function animationTimerListener(event)

	if text.text == "0.0" then
		text.text = "o.o"
		timer.performWithDelay( math.random(1000) + 300, animationTimerListener, 1 )
	elseif text.text == "o.o" then
		text.text = "0.0"
		timer.performWithDelay( math.random(20000), animationTimerListener, 1 )
	else
		timer.performWithDelay( math.random(10000), animationTimerListener, 1 )
	end

end

timer.performWithDelay( math.random(10000), animationTimerListener, 1 )
