-- 
-- Abstract: Destroy sample project
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

-- Add all physics objects
local left_side_piece = display.newRect( -40, display.contentHeight-220, 400, 70 )
physics.addBody( left_side_piece, "static" )
left_side_piece.rotation = 80

local center_piece = display.newRect( display.contentCenterX, display.contentHeight-16, 400, 120 )
physics.addBody( center_piece, "static" )

local right_side_piece = display.newRect( display.contentWidth+40, display.contentHeight-220, 400, 70 )
physics.addBody( right_side_piece, "static" )
right_side_piece.rotation = -80


-- Forward declarations
local touchIsActive = false
local box


-- Function to create/move/remove box
local function onTouch( event )

	if "began" == event.phase then

		touchIsActive = true

		box = display.newRect( event.x, event.y, 32, 32 )
		box.strokeWidth = 1
		box:setStrokeColor( 0.4 )
		box:setFillColor( 1, 1, 1, 0.2 )

	elseif "moved" == event.phase then

		box.x = event.x
		box.y = event.y

	elseif "ended" == event.phase or "cancelled" == event.phase then

		touchIsActive = false
		display.remove( box )
	end

	return true
end
Runtime:addEventListener( "touch", onTouch )


-- Create the particle system
local particleSystem = physics.newParticleSystem{
	filename = "particle.png",
	colorMixingStrength = 0.1,
	radius = 3,
	imageRadius = 6
}

-- Paramaters for red particle faucet
local particleParams_red =
{
	flags = { "water", "colorMixing" },
	linearVelocityX = 256,
	linearVelocityY = -480,
	color = { 1, 0, 0.1, 1 },
	x = 0,
	x = display.contentWidth * 0.15,
	x = display.contentWidth * -0.15,
	y = 0,
	lifetime = 8.0,
	radius = 10,
}

-- Paramaters for blue particle faucet
local particleParams_blue =
{
	flags = { "water", "colorMixing" },
	linearVelocityX = -256,
	linearVelocityY = -480,
	color = { 0, 0.3, 1, 1 },
	x = display.contentWidth * 1.15,
	y = 0,
	lifetime = 8.0,
	radius = 10,
}

-- Generate particles on repeating timer
local function onTimer( event )
	particleSystem:createGroup( particleParams_red )
	particleSystem:createGroup( particleParams_blue )
end
timer.performWithDelay( 100, onTimer, 0 )


-- Function to queryRegion() on 'particleSystem'
local function enterFrame( event )

	if touchIsActive then

		local number_of_particles_destroyed

		if true then

			number_of_particles_destroyed = particleSystem:destroyParticles{
				x = box.x,
				y = box.y,
				angle = 45,
				halfWidth = 16,
				halfHeight = 16
			}
		elseif false then

			number_of_particles_destroyed = particleSystem:destroyParticles{
				x = box.x,
				y = box.y,
				radius = 16
			}
		else

			number_of_particles_destroyed = particleSystem:destroyParticles{
				x = box.x,
				y = box.y,
				angle = -45,
				shape = { 0,0, 0,48, 48,48 }
			}
		end

		--print( number_of_particles_destroyed )
	end
end
Runtime:addEventListener( "enterFrame", enterFrame )

-- Display instructions
local inst = display.newText( "touch/drag to remove particles", display.contentWidth * 0.5, 50, native.systemFont, 16 )
inst:setFillColor( 1 )
