-- 
-- Abstract: Bouncing fruit, using enterFrame listener for animation
-- 
-- Version: 1.3 (uses new viewableContentHeight, viewableContentWidth properties)
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

-- Demonstrates a simple way to perform animation, using an "enterFrame" listener to trigger updates.
--
-- Supports Graphics 2.0
------------------------------------------------------------

local xpos = display.contentCenterX
local ypos = display.contentCenterY

local background = display.newImage( "grass.png", xpos, ypos )

local radius = 40

local xdirection = 1
local ydirection = 1

local xspeed = 7.5
local yspeed = 6.4

local fruit = display.newImage( "fruit.png", xpos, ypos )

-- Get current edges of visible screen (accounting for the areas cropped by "zoomEven" scaling mode in config.lua)
local screenTop = display.screenOriginY
local screenBottom = display.viewableContentHeight + display.screenOriginY
local screenLeft = display.screenOriginX
local screenRight = display.viewableContentWidth + display.screenOriginX

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

Runtime:addEventListener( "enterFrame", animate );
    