-- 
-- Abstract: PolyLines sample app, demonstrating how to draw shapes using line segments
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.
--
-- History
--	12/15/2015		Modified for landscape/portrait modes for tvOS
---------------------------------------------------------------------------------------


display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "background", 0.2 )

-- Example of shape drawing function
local function newStar()
	-- Points of the line to stroke, in the shape of a star.
	-- To prevent odd stroke graphics, have the start/end point of the star be a flat, level area.
	return display.newLine( -50,-35, -27,-35, 0,-110, 27,-35, 105,-35, 43,16, 65,90, 0,45, -65,90, -43,15, -105,-35, -50,-35 )
end

-- Create stars with random color and position
local stars = {}

for i = 1, 20 do

	local myStar = newStar()
	
	myStar:setStrokeColor( math.random(255)/255, math.random(255)/255, math.random(255)/255, math.random(200)/255 + 55/255 )
	myStar.strokeWidth = math.random(10) + 5
	
	myStar.xScale = math.random(100)/100 + 0.5
	myStar.yScale = myStar.xScale

	-- Line display objects don't support anchor points. To rotate the stars about a point, put them in a group.
	local starGroup = display.newGroup()
	starGroup:insert(myStar)
	starGroup.anchorChildren = true
	starGroup.rotation = math.random(360)
	
	starGroup.x = math.random( display.contentWidth )
	starGroup.y = math.random( display.contentHeight )
	
	local dr = math.random( 1, 4 )
	starGroup.dr = dr
	if ( math.random() < 0.5 ) then
		starGroup.dr = -dr
	end

	table.insert( stars, starGroup )
end


function stars:enterFrame( event )

	for i,v in ipairs( self ) do
		v.rotation = ( v.rotation + v.dr ) % 360
	end
end

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

	-- Iterate through the ball array and reset the location to center of the screen
	for i = 1, #stars  do
		stars[ i ].x = math.random( display.contentWidth )
		stars[ i ].y = math.random( display.contentHeight )
	end

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

Runtime:addEventListener( "enterFrame", stars )

