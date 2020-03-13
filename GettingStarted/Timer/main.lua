
-- Abstract: Timer
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="whiteorange", title="Timer", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Require libraries/plugins
local widget = require( "widget" )

-- Set app font
local appFont = sampleUI.appFont

-- Set local variables
local timeDelay = 100  -- 1/10th of a second ( 1000 milliseconds / 10 = 100 )
local timerIterations = 600  -- Set the timer limit to 60 seconds ( 600 * 0.1 = 60 )
local runMode = "stopped"
local startTime = 0
local pausedAt = 0

-- Forward references
local timerText, pauseResumeButton, cancelButton, timerID


-- Called when the app's view has been resized (orientation changed)
local function onResize( event )
	pauseResumeButton.x = display.contentCenterX
	pauseResumeButton.y = display.contentHeight - 100
	cancelButton.x = display.contentCenterX
	cancelButton.y = display.contentHeight - 50
	timerText.x = display.contentCenterX - 15
end
Runtime:addEventListener( "resize", onResize )


-- Button handler function
local buttonHandler = function( event )

	if ( event.target.id == "pauseResume" ) then

		if ( runMode == "running" ) then
			runMode = "paused"
			pauseResumeButton:setLabel( "Resume" )
			pausedAt = event.time
			timer.pause( timerID )

		elseif( runMode == "paused" ) then
			runMode = "running"
			pauseResumeButton:setLabel( "Pause" )
			timer.resume( timerID )

		elseif( runMode == "stopped" ) then
			runMode = "running"
			pauseResumeButton:setLabel( "Pause" )
			timerText.text = "0.0"
			timerID = timer.performWithDelay( timeDelay, timerText, timerIterations )
			startTime = 0
			pausedAt = 0
		end
	
	elseif ( event.target.id == "cancel" ) then

		runMode = "stopped"
		pauseResumeButton:setLabel( "Start" )
		timerText.text = "0.0"
		if ( timerID ) then
			timer.cancel( timerID )
			timerID = nil
		end
		startTime = 0
		pausedAt = 0
	end
end


-- Create buttons
pauseResumeButton = widget.newButton(
	{
		id = "pauseResume",
		label = "Start",
		x = display.contentCenterX,
		y = display.contentHeight - 100,
		width = 160,
		height = 32,
		font = appFont,
		fontSize = 16,
		shape = "rectangle",
		fillColor = { default={ 0.9,0.37,0.05,1 }, over={ 0.945,0.386,0.053,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = buttonHandler
	})
mainGroup:insert( pauseResumeButton )

cancelButton = widget.newButton(
	{
		id = "cancel",
		label = "Cancel",
		x = display.contentCenterX,
		y = display.contentHeight - 50,
		width = 160,
		height = 32,
		font = appFont,
		fontSize = 16,
		shape = "rectangle",
		fillColor = { default={ 0.55,0.125,0.125,1 }, over={ 0.66,0.15,0.15,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,1 } },
		onRelease = buttonHandler
	})
mainGroup:insert( cancelButton )

-- In order for the right-aligned timer to display nicely, we need a font that has monospaced digits
-- Usually this is the system font and we can detect it by measuring the relative widths of the "1" and "2" characters
local bestFontForDevice = nil
local testText = display.newText( { x=-1000, y=-1000, text="1", font=native.systemFontBold, fontSize=24 } )
local width1 = testText.width
testText.text = "2"
local width2 = testText.width
display.remove( testText )

if ( width2 > width1 ) then
	-- The system font doesn't have monospaced digits, so use a font known to have them
	bestFontForDevice = ( system.getInfo("platform") == "win32" and "Courier New" or "Helvetica Neue" )
else
	-- The system font has monospaced digits
	bestFontForDevice = native.systemFontBold
end

-- Create timer text object
timerText = display.newText(
	{
		parent=mainGroup,
		text="0.0",
		x=display.contentCenterX-15,
		y=105,
		width=310,
		font=bestFontForDevice,
		fontSize=140,
		align="right"
	})
timerText:setFillColor( 0 )


-- Timer function
function timerText:timer( event )

	if ( startTime == 0 ) then
		startTime = event.time
	end

	if ( pausedAt > 0 ) then
		startTime = startTime + ( event.time - pausedAt )
		pausedAt = 0
	end

	self.text = string.format( "%.1f", (event.time - startTime)/1000 )

	if ( ( event.time - startTime ) >= ( timerIterations * timeDelay ) ) then
		print( "Resetting timer..." )
		buttonHandler( { target={ id="cancel" } } )
	end
end
