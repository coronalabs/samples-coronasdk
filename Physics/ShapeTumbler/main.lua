-- 
-- Abstract: ShapeTumbler sample project
-- Demonstrates polygon body constructor and tilt-based gravity effects (on device only)
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
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
physics.setGravity( 0, 9.8 ) -- initial gravity points downwards

system.setAccelerometerInterval( 100 ) -- set accelerometer to maximum responsiveness

-- Build this demo for iPhone to see accelerometer-based gravity
function onTilt( event )
	physics.setGravity( ( 9.8 * event.xGravity ), ( -9.8 * event.yGravity ) )
end

Runtime:addEventListener( "accelerometer", onTilt )

display.setStatusBar( display.HiddenStatusBar )

local bkg = display.newImage( "bkg_wood.png", centerX, centerY )

borderBodyElement = { friction=0.5, bounce=0.3 }

display.setDefault( "anchorX", 0.0 )	-- default to TopLeft anchor point for new objects
display.setDefault( "anchorY", 0.0 )

local borderTop = display.newRect( 0, 0, 320, 20 )
borderTop:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderTop, "static", borderBodyElement )

local borderBottom = display.newRect( 0, 460, 320, 20 )
borderBottom:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderBottom, "static", borderBodyElement )

local borderLeft = display.newRect( 0, 20, 20, 460 )
borderLeft:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderLeft, "static", borderBodyElement )

local borderRight = display.newRect( 300, 20, 20, 460 )
borderRight:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderRight, "static", borderBodyElement )

display.setDefault( "anchorX", 0.5 )	-- restore anchor points for new objects to center anchor point
display.setDefault( "anchorY", 0.5 )

local triangle = display.newImage("triangle.png", 80, 160 )

local triangle2 = display.newImage("triangle.png", 170, 160)

local pentagon = display.newImage("pentagon.png", 80, 70)

local pentagon2 = display.newImage("pentagon.png", 170, 70)

local crate = display.newImage("crate.png", 150, 250)

local crateB = display.newImage("crateB.png", 250, 250)

local crateC = display.newImage("crateC.png", 260, 50)

local soccerball = display.newImage("soccer_ball.png", 80, 320)

local superball = display.newImage("super_ball.png", 260, 340)

local superball2 = display.newImage("super_ball.png", 240, 130)

local superball3 = display.newImage("super_ball.png", 250, 180)

triangleShape = { 0,-35, 37,30, -37,30 }
pentagonShape = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }

physics.addBody( crate, { density=2, friction=0.5, bounce=0.4 } )
physics.addBody( crateB, { density=4, friction=0.5, bounce=0.4 } )
physics.addBody( crateC, { density=1, friction=0.5, bounce=0.4 } )

physics.addBody( triangle, { density=0.9, friction=0.5, bounce=0.3, shape=triangleShape } )
physics.addBody( triangle2, { density=0.9, friction=0.5, bounce=0.3, shape=triangleShape } )

physics.addBody( pentagon, { density=0.9, friction=0.5, bounce=0.4, shape=pentagonShape } )
physics.addBody( pentagon2, { density=0.9, friction=0.5, bounce=0.4, shape=pentagonShape } )

physics.addBody( soccerball, { density=0.9, friction=0.5, bounce=0.6, radius=38 } )
physics.addBody( superball, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )
physics.addBody( superball2, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )
physics.addBody( superball3, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )