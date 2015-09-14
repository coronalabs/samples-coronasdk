--
-- Abstract: Container sample app
--
-- Date: September 10, 2010
--
-- Version: 1.1
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, orientation, object touch
--
-- File dependencies: none
--
-- Target devices: Simulator and devices
--
-- Limitations:
--
-- Update History:
--	v1.2  Use .wav sound
--
-- Comments: 
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local w, h = display.contentWidth, display.contentHeight

local container = display.newContainer( w, h )
container:translate( display.contentCenterX, display.contentCenterY )

local bkgd = display.newImage( container, "world.jpg" )
bkgd.fill.effect = "filter.posterize"
bkgd.fill.effect.colorsPerChannel = 7

local myText = display.newText( container, "Hello, World!", 0, 0, native.systemFont, 40 )
myText:setFillColor( 1, 1, 0 )

-- Mask the container
local mask = graphics.newMask( "circlemask.png" )
container:setMask( mask )
container.maskScaleX = 2
container.maskScaleY = 2

transition.to( container, { height = 0.5*h, width = 0.1*h, time=3000, delay=1000} )
