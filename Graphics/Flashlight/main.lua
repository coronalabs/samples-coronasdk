
-- Abstract: Flashlight
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Flashlight", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Local variables and forward references
local centerX, centerY = display.contentCenterX, display.contentCenterY
local radiusMax = math.sqrt( centerX*centerX + centerY*centerY )

-- Set app font
local appFont = sampleUI.appFont

-- Black background
local background = display.newRect( mainGroup, centerX, centerY, display.actualContentWidth, display.actualContentHeight )
background:setFillColor( 0 )

-- Image to be masked
local image = display.newImageRect( mainGroup, "balloon.jpg", 360, 570 )
image.x, image.y = centerX, centerY

-- Create and apply mask
local mask = graphics.newMask( "circlemask.png" )
image:setMask( mask )

-- Instructions
local shade = display.newRect( mainGroup, centerX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
shade:setFillColor( 0.1, 0.1, 0.1, 0.8 )
local msg = display.newText( mainGroup, "Move the light beam to reveal image", centerX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0.9, 0.2 )

-- Touch/drag function
local function onTouch( event )

	local t = event.target
	local phase = event.phase
	
	if ( "began" == phase ) then

		display.currentStage:setFocus( t )
		t.isFocus = true
		-- Store initial position
		t.x0 = event.x - t.maskX
		t.y0 = event.y - t.maskY

	elseif ( t.isFocus ) then

		if ( "moved" == phase ) then

			-- Move beam relative to initial grab point
			local maskX = event.x - t.x0
			local maskY = event.y - t.y0
			t.maskX = maskX
			t.maskY = maskY

			-- Stretch beam as it moves further away from the screen's center
			local radius = math.sqrt( maskX*maskX + maskY*maskY )
			local scaleDelta = radius/radiusMax
			t.maskScaleX = 1 + scaleDelta
			t.maskScaleY = 1 + 0.2 * scaleDelta

			-- Rotate beam appropriately about screen center
			local rotation = math.deg( math.atan2( maskY, maskX ) )
			t.maskRotation = rotation

		elseif ( "ended" == phase or "cancelled" == phase ) then

			display.currentStage:setFocus( nil )
			t.isFocus = false
		end
	end
	return true
end

-- Add touch listener to image
image:addEventListener( "touch", onTouch )

-- By default, the mask will limit touch detection to areas that lie inside both the mask and
-- the image being masked; this can be overridden by setting the following property to false
image.isHitTestMasked = false
