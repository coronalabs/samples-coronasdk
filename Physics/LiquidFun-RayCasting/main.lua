-- 
-- Abstract: RayCast sample project
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


-- Create ray line
local ray
local ray_from_x = 64
local ray_from_y = 320
local ray_to_x = 256
local ray_to_y = 384

local unbroken_ray = display.newLine( ray_from_x, ray_from_y, ray_to_x, ray_to_y )
unbroken_ray.strokeWidth = 2
unbroken_ray:setStrokeColor( 1, 0, 0.1, 1 )


-- Forward declarations
local orderLabels = {}


-- Debug output function
local function debugOutput( hits )

	print( "Hit count: ", #hits )

	-- Output the results
	for i,v in ipairs( hits ) do
		print( "Hit: ", i, " Position: ", v.x, v.y, " Surface normal: ", v.normalX, v.normalY, " Fraction: ", v.fraction )
	end
end


-- Function to show hit labels
local function showHitLabels( hits )

	for i,v in ipairs( hits ) do
		orderLabels[i] = display.newText( tostring( i ), v.x, v.y, native.systemFont, 14 )
		orderLabels[i]:setFillColor( 1 )
	end
end


-- Function to draw new line to the hit point
local drawHitLine = function( hit )
	--draw a line to the hit
	ray = display.newLine( ray_from_x, ray_from_y, hit.x, hit.y )
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


-- Function to rayCast() on 'particleSystem'
local function enterFrame( event )

	display.remove( ray ) ; ray = nil

	for i = #orderLabels,1,-1 do
		display.remove( orderLabels[i] )
	end

	--the default behavior is "closest" when none other is specified
	--local hits = particleSystem:rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "closest" )
	--local hits = particleSystem:rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "any" )
	--local hits = particleSystem:rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "sorted" )
	--local hits = particleSystem:rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y, "unsorted" )
	local hits = particleSystem:rayCast( ray_from_x, ray_from_y, ray_to_x, ray_to_y )

	if hits then

		--debugOutput( hits )
		showHitLabels( hits )

		--the first hit:
		local hit = hits[1]
		--the last hit:
		--local hit = hits[#hits]

		drawHitLine( hit )
	else

		--there's no hit
		ray = display.newLine( ray_from_x, ray_from_y, ray_to_x, ray_to_y )
	end

	ray.strokeWidth = 2
end
Runtime:addEventListener( "enterFrame", enterFrame )

-- Display instructions
local inst = display.newText( "drag box to alter faucet path", display.contentWidth * 0.5, 50, native.systemFont, 16 )
inst:setFillColor( 1 )
