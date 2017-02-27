-- 
-- Abstract: QueryRegion sample project
-- 
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2014 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()
physics.setDrawMode( "normal" )

display.setStatusBar( display.HiddenStatusBar )
display.setDefault( "fillColor", 0.5 )

local gameUI = require( "gameUI" )


-- Add all physics objects
local left_side_piece = display.newRect( -40, display.contentHeight-220, 400, 70 )
physics.addBody( left_side_piece, "static" )
left_side_piece.rotation = 80

local center_piece = display.newRect( display.contentCenterX, display.contentHeight-16, 400, 120 )
physics.addBody( center_piece, "static" )

local right_side_piece = display.newRect( display.contentWidth+40, display.contentHeight-220, 400, 70 )
physics.addBody( right_side_piece, "static" )
right_side_piece.rotation = -80

local crate = display.newRect( 0,0,60,60 )
crate.x, crate.y = 120,392
crate:setFillColor( 222.0/255.0, 184.0/255.0, 135.0/255.0 )
physics.addBody( crate, "dynamic", { density=0.8 } )
crate.gravityScale = 0.6
crate:addEventListener( "touch", gameUI.dragBody )


-- Create center query region box
display.setDefault( "anchorX", 0.0 ) ; display.setDefault( "anchorY", 0.0 )

local box_spec = {
	upper_left = { x=100, y=160 },
	lower_right = { x=220, y=280 },
	width = 0,
	height = 0
	}
box_spec.width = ( box_spec.lower_right.x - box_spec.upper_left.x )
box_spec.height = ( box_spec.lower_right.y - box_spec.upper_left.y )

local box = display.newRect( box_spec.upper_left.x,
								box_spec.upper_left.y,
								box_spec.width,
								box_spec.height )
box.strokeWidth = 1
box:setStrokeColor( 0.4 )
box:setFillColor( 1, 1, 1, 0.2 )
display.setDefault( "anchorX", 0.5 ) ; display.setDefault( "anchorY", 0.5 )


-- Forward declarations
local hitLabels = {}


-- Debug output function
local function debugOutput( hits )

	print( "Hit count: ", #hits )

	-- Output the results
	--for i,v in ipairs( hits ) do
	--	print( "Hit: ", i, " Position: ", v.x, v.y )
	--end
end


-- Function to show hit labels
local function showHitLabels( hits )

	for i,v in ipairs( hits ) do
		hitLabels[i] = display.newText( tostring( i ), v.x, v.y, native.systemFont, 14 )
		hitLabels[i]:setFillColor( 1 )
	end
end


-- Create the particle system
local particleSystem = physics.newParticleSystem{
	filename = "particle.png",
	radius = 3,
	imageRadius = 6
}


-- Paramaters for particle faucet
local particleParams =
{
	flags = "water",
	velocityX = 380,
	velocityY = -480,
	color = { 0, 0.3, 1, 1 },
	x = -40,
	y = 100,
	lifetime = 32.0
}

-- Generate particles on repeating timer
local function onTimer( event )
	particleSystem:createParticle( particleParams )
end
timer.performWithDelay( 20, onTimer, 0 )


-- Function to queryRegion() on 'particleSystem'
local function enterFrame( event )

	--clean up hit labels
	for i = #hitLabels,1,-1 do
		display.remove( hitLabels[i] )
	end

	local hits = particleSystem:queryRegion(
		box_spec.upper_left.x,
		box_spec.upper_left.y,
		box_spec.lower_right.x,
		box_spec.lower_right.y
		)

	if hits then
		--debugOutput( hits )
		showHitLabels( hits )
		box:setStrokeColor( 1, 0.3, 0.2, 0.6 )
		box:setFillColor( 1, 0.3, 0.2, 0.3 )
	else
		box:setStrokeColor( 0.4 )
		box:setFillColor( 1, 1, 1, 0.2 )
	end
end
Runtime:addEventListener( "enterFrame", enterFrame )

-- Display instructions
local inst = display.newText( "drag box to alter faucet path", display.contentWidth * 0.5, 50, native.systemFont, 16 )
inst:setFillColor( 1 )
