--
-- Abstract: Master Blend Mode sample app
--
-- Date: September 10, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, shaders, filters
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
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local x,y = display.contentCenterX, display.contentCenterY
local w,h = display.contentWidth, display.contentHeight

local o = display.newRect( x, y, w, h )
o:setFillColor( 255, 0, 0)

local o = display.newImage( "aquariumbackgroundIPhone.jpg", x, y )
local m = graphics.newMask( "fish.small.red.png" )
o:setMask( m )
o.maskScaleX = 3
o.maskScaleY = 3
o.blendMode = "xor"