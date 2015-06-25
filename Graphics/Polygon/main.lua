-- 
-- Abstract: PolyLines sample app, demonstrating how to draw shapes using line segments
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.

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