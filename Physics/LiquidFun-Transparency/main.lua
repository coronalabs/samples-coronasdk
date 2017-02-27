
-- Abstract: LiquidFun-Transparency
-- Version: 1.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
-- Assets copyright © 2015 Frozen Gun Games. All rights reserved.
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Liquid Transparency", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local worldGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set up physics engine
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 9.8 )
physics.setDrawMode( "normal" )

-- Declare initial variables
local letterboxWidth = (display.actualContentWidth-display.contentWidth)/2
local letterboxHeight = (display.actualContentHeight-display.contentHeight)/2

-- Add three physics objects as borders for the simulated liquid, located outside the visible screen
local leftSide = display.newRect( worldGroup, -54-letterboxWidth, display.contentHeight-180, 600, 70 )
physics.addBody( leftSide, "static" )
leftSide.rotation = 86

local centerPiece = display.newRect( worldGroup, display.contentCenterX, display.contentHeight+60+letterboxHeight, 440, 120 )
physics.addBody( centerPiece, "static" )

local rightSide = display.newRect( worldGroup, display.contentWidth+54+letterboxWidth, display.contentHeight-180, 600, 70 )
physics.addBody( rightSide, "static" )
rightSide.rotation = -86

-- Create an endless scrolling background, using background image from "Freeze!"
local background1 = display.newImageRect( worldGroup, "background.png", 320, 480 )
background1.x = 160
background1.y = 240
background1.xScale = 1.202
background1.yScale = 1.200
transition.to( background1, { time=12000, x=-224, iterations=0 } )

local background2 = display.newImageRect( worldGroup, "background.png", 320, 480 )
background2.x = 544
background2.y = 240
background2.xScale = 1.202
background2.yScale = 1.200
transition.to( background2, { time=12000, x=160, iterations=0 } )

-- Create our eye (the hero of "Freeze!")
local hero = display.newImageRect( worldGroup, "hero.png", 64, 64 )
hero.x = 160
hero.y = -400
physics.addBody( hero, { density=0.7, friction=0.3, bounce=0.2, radius=30 } )

-- Make hero draggable via a touch handler and physics touch joint
local function dragBody( event )
	local body = event.target
	local phase = event.phase

	if ( "began" == phase ) then
		display.getCurrentStage():setFocus( body, event.id )
		body.isFocus = true
		body.tempJoint = physics.newJoint( "touch", body, event.x, event.y )
		body.isFixedRotation = true
	elseif ( body.isFocus ) then
		if ( "moved" == phase ) then
			body.tempJoint:setTarget( event.x, event.y )
		elseif ( "ended" == phase or "cancelled" == phase ) then
			display.getCurrentStage():setFocus( body, nil )
			body.isFocus = false
			event.target:setLinearVelocity( 0,0 )
			event.target.angularVelocity = 0
			body.tempJoint:removeSelf()
			--body.isFixedRotation = false  -- Use this line if the eye should rotate in the water
		end
	end
	return true
end
hero:addEventListener( "touch", dragBody )

-- Create the LiquidFun particle system for the water
local particleSystem = physics.newParticleSystem{
	filename = "liquidParticle.png",
	radius = 3,
	imageRadius = 5,
	gravityScale = 1.0,
	strictContactCheck = true
}

-- Create a "block" of water (LiquidFun group)
particleSystem:createGroup(
    {
        flags = { "tensile" },
        x = 160,
        y = 0,
        color = { 0.1, 0.1, 0.1, 1 },
        halfWidth = 128,
        halfHeight = 256
    }
)

-- Initialize snapshot for full screen
local snapshot = display.newSnapshot( worldGroup, 320+letterboxWidth+letterboxWidth, 480+letterboxHeight+letterboxHeight )
local snapshotGroup = snapshot.group
snapshot.x = 160
snapshot.y = 240
snapshot.canvasMode = "discard"
snapshot.alpha = 0.3

-- Apply a "sobel" filter to portray the visible surface of the water
snapshot.fill.effect = "filter.sobel"

-- Insert the particle system into the snapshot
snapshotGroup:insert( particleSystem )
snapshotGroup.x = -160
snapshotGroup.y = -240

-- Bring hero to front of its display group
hero:toFront()

-- Update (invalidate) the snapshot each frame
local function onEnterFrame( event )
	snapshot:invalidate()
end
Runtime:addEventListener( "enterFrame", onEnterFrame )
