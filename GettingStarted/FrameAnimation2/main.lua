-- 
-- Abstract: FrameAnimation2 -- bouncing balls animated with table listeners for the "enterFrame" event
-- 
-- Version: 1.2 (uses new viewableContentHeight, viewableContentWidth properties)
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

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
-- Supports Graphics 2.0
------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "background", 80/255 )

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

-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX

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

Runtime:addEventListener( "enterFrame", collection );
    