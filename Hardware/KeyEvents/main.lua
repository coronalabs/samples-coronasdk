
-- Abstract: KeyEvents
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Key Events", showBuildNum=false } )

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

-- Local variables and forward references
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Create text labels at the center of the screen for display key event info
local keyTxt = display.newText( { parent=mainGroup, text="...", x=centerX, y=centerY-10, font=appFont, fontSize=28, align="center" } )
keyTxt:setFillColor( 1, 0.7, 0.35 )
local phaseTxt = display.newText( { parent=mainGroup, text="", x=centerX, y=centerY+18, font=appFont, fontSize=22, align="center" } )
phaseTxt:setFillColor( 1, 0.4, 0.25 )

-- Create a message area and text object
local shade = display.newRect( mainGroup, centerX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
shade:setFillColor( 0, 0, 0, 0.7 )
local msg = display.newText( mainGroup, "", centerX, shade.y, appFont, 13 )

-- Detect if key events are supported
local platform = system.getInfo( "platform" )
if not system.hasEventSource( "key" ) or ( system.getInfo("environment") == "device" and ( platform == "ios" or platform == "tvos" ) ) then
	msg.text = "(connect remote or game controller)"
	msg:setFillColor( 1, 0, 0.2 )
	local alert = native.showAlert( "Note", "Mobile devices require a remote or game controller to receive key events.", { "OK" } )
else
	msg.text = "Waiting for key event..."
	msg:setFillColor( 1, 0.9, 0.2 )
end

local function onInputDeviceStatusChanged( event )
	if ( event.connectionStateChanged and event.device and event.device.isConnected == true ) then
		msg.text = "Waiting for key event..."
		msg:setFillColor( 1, 0.9, 0.2 )
	end
end

-- The key event listener
local function onKeyEvent( event )

	-- Output which key was pressed down/up to the console
	print( '"' .. event.keyName .. '" : ' .. event.phase )

	-- Display the key event information on screen
	keyTxt.text = event.keyName
	phaseTxt.text = event.phase

	-- If the Android "back" key was pressed, prevent it from backing out of the app
	-- This is done by returning true, telling the operating system to override the key
	if ( event.keyName == "back" ) then
		return true
	end

	-- Return false to indicate that this app is NOT overriding the received key
	-- This lets the operating system execute its default handling of the key
	return false
end

-- Add key event listener
Runtime:addEventListener( "key", onKeyEvent )

-- Add listener for input device status
Runtime:addEventListener( "inputDeviceStatus", onInputDeviceStatusChanged )
