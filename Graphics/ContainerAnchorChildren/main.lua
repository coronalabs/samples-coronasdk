--
-- Abstract: Container Anchor Children sample app
--
-- Date: September 10, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics
--
-- File dependencies: none
--
-- Target devices: Simulator and devices
--
-- Limitations:
--
-- Update History:
--
-- Comments: 
--
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local x,y = display.contentCenterX, display.contentCenterY

-- Create container
local w,h = 320, 240
local container = display.newContainer( 320, 240 )
container:translate( x, y )

-- Place image, but inside container
local bkgd = display.newImage( container, "aquariumbackgroundIPhone.jpg" )
bkgd.fill.effect = "filter.sepia"

local myText = display.newText( "Hello, World!", 0, 0, native.systemFont, 40 )
myText:setFillColor( 1,1,0 )
container:insert( myText )
container.anchorY=1

-- When anchor changes, children do not move with container. Normally, they do
container.anchorChildren = false

-- When we tap, the anchor point 
container:addEventListener( "tap", function()
	transition.to( container, {anchorY=0.5, time=1000 } )
end )