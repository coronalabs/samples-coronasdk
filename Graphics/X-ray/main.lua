-- Abstract: X-ray sample project
-- Demonstrates masking an image
--
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- 2013.01.27 Added HitTest switch
--
-- Supports Graphics 2.0
------------------------------------------------------------

local widget = require "widget"

display.setStatusBar( display.HiddenStatusBar )

local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Background image
local bkg = display.newImage( "paper_bkg.png", centerX, centerY, true )
bkg.x = centerX
bkg.y = centerY

-- Image that the x-ray reveals. In display object rendering,
-- this is above the background. The mask effect makes it look
-- underneath
local image = display.newImage( "grid.png", centerX, centerY, true )
image.alpha = 0.7

-- The mask that creates the X-ray effect.
local mask = graphics.newMask( "circlemask.png" )
image:setMask( mask )

function onTouch( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )

		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.maskX
		t.y0 = event.y - t.maskY
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.maskX = event.x - t.x0
			t.maskY = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	return true
end
image:addEventListener( "touch", onTouch )

-- By default, the mask will limit the touch region to areas that lie inside 
-- both the mask and the image being masked.  We can override this by setting the
-- isHitTestMasked property to false, so the touch region lies inside the entire image. 
image.isHitTestMasked = false

-- Display instructions
local labelFont = native.systemFont
local myLabel = display.newText( "Move circle to see behind paper", centerX, 200, labelFont, 30)
myLabel:setFillColor( 1, 1, 1, 180/255 )

-- create Hit Test button
-- Sets/clears the isHitTestMask on the image
--
hitButton = widget.newButton
{
	label = "Enable Hit Test Mask",
	fontSize = 32,
	width = display.contentWidth * 0.4,
	onRelease = function( event )
		if image.isHitTestMasked then
			hitButton:setLabel( "Enable Hit Test Mask" )
			image.isHitTestMasked = false
		else
			hitButton:setLabel( "Disable Hit Test Mask" )
			image.isHitTestMasked = true
		end
	end
}
hitButton.x = centerX
hitButton.y = display.contentHeight - 60
