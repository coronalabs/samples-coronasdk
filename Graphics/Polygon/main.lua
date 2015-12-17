-- Abstract: PolyLines sample app, demonstrating how to draw shapes using line segments
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.
--
-- History
--	12/15/2015		Modified for landscape/portrait modes for tvOS
---------------------------------------------------------------------------------------

--display.setDrawMode( "wireframe")

local vertices = { 0,-110, 27,-35, 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -27,-35, }

--display.setDefault( "background", 128 )
--[[
local vertices = {
	0,-110,
	65,90,
	-105,-35,
	105,-35,
	-65,90,
}
--]]

local x,y = display.contentCenterX, display.contentCenterY
local o = display.newPolygon( x, y, vertices )
o:setFillColor( 255, 0, 0 )
o.fill = { type="image", filename="aquariumbackgroundIPhone.jpg" }
--o.fill = nil
o.strokeWidth = 10
o:setStrokeColor( 0, 255, 255 )

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

	o.x = display.contentCenterX		-- find new center of screen
	o.y = display.contentCenterY		-- find new center of screen
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