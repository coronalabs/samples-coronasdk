-- 
-- Abstract: FrameAnimation2 -- bouncing balls animated with table listeners for the "enterFrame" event
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.

-- Demonstrates how to use table listeners for event handling, for more of an object-oriented
-- approach. This is an example of one convenient way to structure and organize code.
--
-- Note how all of the variables accessed inside the enterFrame method are local.
-- Also, note that for table listeners, the method name must be the same as the event 
-- you register for.
--
-- Like "FrameAnimation1", this is frame-based animation. See "TimeAnimation" for an example of
-- how to do time-based, framerate-independent animation.
--
-- History
--	12/15/2015		Modified for landscape/portrait modes for tvOS
---------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "background", 80/255 )

local screenTop 
local screenBottom 
local screenLeft
local screenRight

local xpos = display.contentCenterX		-- find new center of screen
local ypos = display.contentCenterY		-- find new center of screen

local function newBall( params )
	local xpos = display.contentWidth*0.5
	local ypos = display.contentHeight*0.5
	local circle = display.newCircle( xpos, ypos, params.radius );
	circle:setFillColor( params.r, params.g, params.b, 255 );
	circle.xdir = params.xdir
	circle.ydir = params.ydir
	circle.xspeed = params.xspeed
	circle.yspeed = params.yspeed
	circle.radius = params.radius

	return circle
end

local params = {
	{ radius=20, xdir=1, ydir=1, xspeed=2.8, yspeed=6.1, r=255, g=0, b=0 },
	{ radius=12, xdir=1, ydir=1, xspeed=3.8, yspeed=4.2, r=255, g=255, b=0 },
	{ radius=15, xdir=1, ydir=-1, xspeed=5.8, yspeed=5.5, r=255, g=0, b=255 },
--	newBall{ radius=10, xdir=-1, ydir=1, xspeed=3.8, yspeed=1.2 }
}

local collection = {}

-- Iterate through params array and add new balls into an array
for _,item in ipairs( params ) do
	local ball = newBall( item )
	collection[ #collection + 1 ] = ball
end

function collection:enterFrame( event )
	for _,ball in ipairs( collection ) do
		local dx = ( ball.xspeed * ball.xdir );
		local dy = ( ball.yspeed * ball.ydir );
		local xNew, yNew = ball.x + dx, ball.y + dy

		local radius = ball.radius
		if ( xNew > screenRight - radius or xNew < screenLeft + radius ) then
			ball.xdir = -ball.xdir
		end
		if ( yNew > screenBottom - radius or yNew < screenTop + radius ) then
			ball.ydir = -ball.ydir
		end

		ball:translate( dx, dy )
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

	xpos = display.contentCenterX		-- find new center of screen
	ypos = display.contentCenterY		-- find new center of screen

-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
	screenTop = display.screenOriginY
	screenBottom = display.viewableContentHeight + display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.viewableContentWidth + display.screenOriginX

	-- Iterate through the ball array and reset the location to center of the screen
	for i = 1, #collection  do
		collection[ i ].x = xpos
		collection[ i ].y = ypos
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

Runtime:addEventListener( "enterFrame", collection );
    