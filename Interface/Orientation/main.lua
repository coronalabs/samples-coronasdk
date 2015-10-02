-- 
-- Abstract: Orientation sample app
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- This demonstrates how to handle orientation changes manually, by rotating elements within
-- Corona. Note that the Corona stage remains fixed in place, and only the text rotates in this case.
-- 
-- The advantage of this method is that you have full control over how to handle the change, as in
-- the animation shown here. The disadvantage is that native UI elements will not rotate.
--
-- Alternatively, you can use the device's automatic orientation changes to rotate the entire stage,
-- which will also rotate native UI elements. See the "NativeOrientation" sample code for more.
--
-- Supports Graphics 2.0
------------------------------------------------------------

display.setDefault( "background", 80/255 )

local label = display.newText( "portrait", display.contentCenterX, display.contentCenterY, nil, 30 )
label:setFillColor( 1, 1, 1 )

-- Rotation values for the main four orientations
local orientationAngles = {
	portrait = 0,
	landscapeRight = 90,
	portraitUpsideDown = 180,
	landscapeLeft = 270,
}

local function onOrientationChange( event )
	local direction = event.type

	-- change text to reflect current orientation
	label.text = event.type

	-- rotate text so it remains upright
	local newAngle = ( orientationAngles[direction] or 0 )
	transition.to( label, { time = 150, rotation = newAngle } )
end

Runtime:addEventListener( "orientation", onOrientationChange )