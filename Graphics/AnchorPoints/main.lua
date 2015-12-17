-- 
-- Abstract: Anchor Points sample app, demonstrating how to use anchor points.
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.
--
-- History
--	12/15/2015		Modified for landscape/portrait modes for tvOS
---------------------------------------------------------------------

display.setDefault( "background", 80/255 )
local secondHand = display.newImageRect("images/clock-hands-hi.png", 412, 64)

secondHand.anchorX = 0.2257
secondHand.anchorY = 0.5

secondHand.x = display.contentCenterX 
secondHand.y = display.contentCenterY

timer.performWithDelay(1000, function() secondHand.rotation = secondHand.rotation + 6; end, 0)

-----------------------------------------------------------------------
-- Change the orientation of the app here
--
-- Adjust objects for Portrait or Landscape mode
--
-- Enter: mode = orientation mode
-----------------------------------------------------------------------
--
function changeOrientation( mode ) 
	print( "changeOrientation ...", mode )

	secondHand.x = display.contentCenterX 
	secondHand.y = display.contentCenterY
end

-----------------------------------------------------------------------
-- Come here on Resize Events
-- Display the Orientation Message on the screen
-----------------------------------------------------------------------
--
function onResizeEvent( event ) 
	print ("onResizeEvent: " .. event.name)
	changeOrientation( system.orientation )
end

-- Set up the display after the app starts
changeOrientation( system.orientation )

-- Add the Orientation callback event
Runtime:addEventListener( "resize", onResizeEvent )
