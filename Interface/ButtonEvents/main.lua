
-- Abstract: ButtonEvents
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Button Events", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

-- Require libraries/plugins
local widget = require( "widget" )

local buttonPhase = display.newText( mainGroup, "(waiting for button event)", display.contentCenterX, 55+display.screenOriginY, appFont, 13 )
buttonPhase:setFillColor( 1, 0.4, 0.25 )

local logo = display.newImageRect( mainGroup, "corona-logo.png", 150, 150 )
logo.x = display.contentCenterX
logo.y = 160 + display.screenOriginY

-- Button event listener function
local function buttonEvent( event )

	buttonPhase.text = '"' .. event.phase .. '"'

	if ( "began" == event.phase ) then
		transition.cancel( "logo" )
		transition.to( logo, { time=200, tag="logo", xScale=0.9, yScale=0.9, transition=easing.outBack } )
	elseif ( "ended" == event.phase or "cancelled" == event.phase ) then
		transition.cancel( "logo" )
		transition.to( logo, { time=200, tag="logo", xScale=1, yScale=1, transition=easing.inBack } )
	end
	return true
end

-- This button uses the "onEvent" listener type which detects all phases of user interaction
local eventButton = widget.newButton(
	{
		label = '"onEvent" listener',
		id = "onEvent",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 280 - display.screenOriginY,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.1,0.3,0.6,1 }, over={ 0.1,0.3,0.6,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onEvent = buttonEvent,  -- Use "onEvent" listener type
	})
mainGroup:insert( eventButton )

-- This button uses the "onPress" listener type which only detects initial touch
local pressButton = widget.newButton(
	{
		label = '"onPress" listener',
		id = "onPress",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 340 - display.screenOriginY,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.45,0.2,0.55,1 }, over={ 0.45,0.2,0.55,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onPress = buttonEvent,  -- Use "onPress" listener type
	})
mainGroup:insert( pressButton )

-- This button uses the "onRelease" listener type which only detects touch lifting off within its bounds
local releaseButton = widget.newButton(
	{
		label = '"onRelease" listener',
		id = "onRelease",
		shape = "rectangle",
		x = display.contentCenterX,
		y = 400 - display.screenOriginY,
		width = 278,
		height = 32,
		font = appFont,
		fontSize = 15,
		fillColor = { default={ 0.7,0.2,0.4,1 }, over={ 0.7,0.2,0.4,1 } },
		labelColor = { default={ 1,1,1,1 }, over={ 1,1,1,0.8 } },
		onRelease = buttonEvent,  -- Use "onRelease" listener type
	})
mainGroup:insert( releaseButton )
