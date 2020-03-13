
-- Abstract: Compass
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="whiteorange", title="Compass", showBuildNum=false } )

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

-- Labels for display
local headingText = display.newText( mainGroup, "0°", display.contentCenterX+25, 85, appFont, 44 )
headingText.anchorX = 1
headingText:setFillColor( 0.5 )

local directionText = display.newText( mainGroup, "N", display.contentCenterX+25, 90, appFont, 22 )
directionText.anchorX = 0
directionText:setFillColor( 0.5 )

local dial = display.newImageRect( mainGroup, "compass_dial.png", 256, 256 )
dial.x, dial.y = display.contentCenterX, display.contentCenterY + 25

local pointer = display.newImageRect( mainGroup, "compass_pointer.png", 16, 16 )
pointer.x, pointer.y = dial.x, dial.y - 136

-- Detect if heading events are supported
if not system.hasEventSource( "heading" ) then
	local shade = display.newRect( mainGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.9 )
	local msg = display.newText( mainGroup, "Heading events not supported on this platform", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
end

-- Function to get direction abbreviation based on angle
local directionForAngle = function( angle )

	local text

	if ( angle <= 22 or angle > 337 ) then
		text = "N"
	elseif ( angle > 22 and angle <= 67 ) then
		text = "NE"
	elseif ( angle > 67 and angle <= 112 ) then
		text = "E"
	elseif ( angle > 112 and angle <= 157 ) then
		text = "SE"
	elseif ( angle > 157 and angle <= 202 ) then
		text = "S"
	elseif ( angle > 202 and angle <= 247 ) then
		text = "SW"
	elseif ( angle > 247 and angle <= 292 ) then
		text = "W"
	elseif ( angle > 292 and angle <= 337 ) then
		text = "NW"
	end

	return text
end

local dstRotation = 0

-- Listener function for heading events
local updateCompass = function( event )

	local angle = event.magnetic
	dstRotation = -angle

	-- Format strings as whole numbers
	local value = string.format( "%.0f", angle )
	-- Concatenate degree sign onto value and update heading text
	headingText.text = value .. "°"
	-- Update direction text based on angle
	directionText.text = directionForAngle( angle )
end

-- Runtime listener to update the dial rotation
local rotateDial = function( event )

	local currentRotation = dial.rotation
	local delta = dstRotation - currentRotation

	if ( math.abs(delta) >= 180 ) then
		if ( delta < -180 ) then
			delta = delta + 360
		elseif ( delta > 180 ) then
			delta = delta - 360
		end
	end

	dial.rotation = currentRotation + delta*0.3
end

-- Compass event listener
Runtime:addEventListener( "heading", updateCompass )

-- Adaptive tweening to smooth the dial animation
Runtime:addEventListener( "enterFrame", rotateDial )
