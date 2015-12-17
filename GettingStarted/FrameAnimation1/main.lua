-- 
-- Abstract: Bouncing fruit, using enterFrame listener for animation
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.

-- Demonstrates a simple way to perform animation, using an "enterFrame" listener to trigger updates.
--
-- History
--	12/15/2015		Modified for landscape/portrait modes for tvOS
------------------------------------------------------------------------------

local screenTop
local screenBottom
local screenLeft
local screenRight
local background

local xpos = display.contentCenterX
local ypos = display.contentCenterY

-- local background = display.newImage( "grass.png", xpos, ypos )

local radius = 40

local xdirection = 1
local ydirection = 1

local xspeed = 7.5
local yspeed = 6.4

local fruit = display.newImage( "fruit.png", xpos, ypos )

local function animate(event)
	xpos = xpos + ( xspeed * xdirection );
	ypos = ypos + ( yspeed * ydirection );

	if ( xpos > screenRight - radius or xpos < screenLeft + radius ) then
		xdirection = xdirection * -1;
	end
	if ( ypos > screenBottom - radius or ypos < screenTop + radius ) then
		ydirection = ydirection * -1;
	end

	fruit:translate( xpos - fruit.x, ypos - fruit.y)
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

	xpos = display.contentCenterX		-- find new center of screen
	ypos = display.contentCenterY		-- find new center of screen

-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX

	if string.find( mode, "portrait") then 
		display.remove( background )
		background = display.newImage( "grass.png", xpos, ypos )
	elseif string.find( mode, "landscape") then
		display.remove( background )
		background = display.newImage( "grass_landscape.png", xpos, ypos )
	end

	fruit.x = xPos
	fruit.y = yPos
	fruit:toFront()
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

Runtime:addEventListener( "enterFrame", animate )