--
-- Abstract: Container Alignment sample app
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

local easing = require "easing"

local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local g = display.newContainer( 150, 150 )
local bkgd = display.newImage( "aquariumbackgroundIPhone.jpg" )
bkgd.fill.effect = "filter.desaturate"
bkgd.fill.effect.intensity = 1

g:insert(bkgd, true )
g:translate( halfW, halfH )

local o = g

-- CHANGE 'alignment' to see how things change
--local anchorX,anchorY = 0.5, 0.5 -- center
--local anchorX,anchorY = 0, 0 -- top left
print( "BEFORE", o.anchorX, o.anchorY, o.x, o.y )
local anchorX,anchorY = 1, 1 -- bottomRight

o.anchorX = anchorX
o.anchorY = anchorY
print( "AFTER ", o.anchorX, o.anchorY, o.x, o.y )

transition.to( o, {rotation = 360, anchorX=0, delay=1000, time=5000, transition=easing.inOutExpo} )
transition.to( bkgd.fill.effect, { intensity = 0, time = 5000 })