-- 
-- Abstract: CollisionFilter sample project
-- Demonstrates "categoryBits" and "maskBits" for collision filtering
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require("physics")
physics.start()

physics.setScale( 60 )

display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImage( "stripes.png", centerX, centerY )

display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

borderCollisionFilter = { categoryBits = 1, maskBits = 6 } -- collides with (4 & 2) only
borderBodyElement = { friction=0.4, bounce=0.8, filter=borderCollisionFilter }

local borderTop = display.newRect( 0, 0, 320, 1 )
borderTop:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderTop, "static", borderBodyElement )

local borderBottom = display.newRect( 0, 479, 320, 1 )
borderBottom:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderBottom, "static", borderBodyElement )

local borderLeft = display.newRect( 0, 1, 1, 480 )
borderLeft:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderLeft, "static", borderBodyElement )

local borderRight = display.newRect( 319, 1, 1, 480 )
borderRight:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderRight, "static", borderBodyElement )


local red = {}
local blue = {}

local redCollisionFilter = { categoryBits = 2, maskBits = 3 } -- collides with (2 & 1) only
local blueCollisionFilter = { categoryBits = 4, maskBits = 5 } -- collides with (4 & 1) only

local redBody = { density=0.2, friction=0, bounce=0.95, radius=43.0, filter=redCollisionFilter }
local blueBody = { density=0.2, friction=0, bounce=0.95, radius=43.0, filter=blueCollisionFilter }


for i = 1,4 do
	red[i] = display.newImage( "red_balloon.png", (80*i)-60, 50 + math.random(20) )
	physics.addBody( red[i], redBody )
	red[i].isFixedRotation = true
	
	blue[i] = display.newImage( "blue_balloon.png", (80*i)-60, 250 + math.random(20) )
	physics.addBody( blue[i], blueBody )
	blue[i].isFixedRotation = true
end