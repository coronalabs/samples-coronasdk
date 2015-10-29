-- 
-- Abstract: ColorGroup sample project
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
math.randomseed( os.time() )


-- Add all physics objects
local left_side_piece = display.newRect( -40, display.contentHeight-220, 400, 70 )
physics.addBody( left_side_piece, "static" )
left_side_piece.rotation = 80

local center_piece = display.newRect( display.contentCenterX, display.contentHeight-16, 400, 120 )
physics.addBody( center_piece, "static" )

local right_side_piece = display.newRect( display.contentWidth+40, display.contentHeight-220, 400, 70 )
physics.addBody( right_side_piece, "static" )
right_side_piece.rotation = -80


-- Debug output function
local function debugOutput( hits )

	print( "Hit count: ", #hits )

	-- Output the results
	--for i,v in ipairs( hits ) do
	--	print( "Hit: ", i, " Position: ", v.x, v.y )
	--end
end


-- Forward declarations
local touchIsActive = false
local previousTime = 0.0
local previousX = 0.0
local previousY = 0.0
local touchX = 0.0
local touchY = 0.0
local velocityX = 0.0
local velocityY = 0.0
local box
local image_outline = graphics.newOutline( 1, "outline.png" )


-- Function to create/move/remove box
local function onTouch( event )

	local timeDelta = ( event.time / 1000.0 ) - previousTime
	if timeDelta > 0 then
		touchX = event.x
		touchY = event.y
		previousTime = ( event.time / 1000.0 )
		local positionDeltaX = touchX - previousX
		local positionDeltaY = touchY - previousY
		previousX = touchX
		previousY = touchY
		velocityX = ( positionDeltaX / timeDelta )
		velocityY = ( positionDeltaY / timeDelta )
	end

	----------------------------------------------------------------------------

	if "began" == event.phase then

		touchIsActive = true
		velocityX = 0.0
		velocityY = 0.0

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


-- Create box
local function createBox( flags, groupFlags, color, x, y )

	local groupParams = {
		flags = flags,
		groupFlags = groupFlags,
		lifetime = 8.0,
		color = color,
		x = x,
		y = y,
		halfWidth = 64,
		halfHeight = 32,
		angle = 360 * math.random(),
	}
	return groupParams
end


-- Create circle
local function createCircle( flags, groupFlags, color, x, y )

	local groupParams = {
		flags = flags,
		groupFlags = groupFlags,
		lifetime = 8.0,
		color = color,
		x = x,
		y = y,
		radius = 32,
	}
	return groupParams
end


-- Create triangle
local function createTriangle( flags, groupFlags, color, x, y )

	local groupParams = {
		flags = flags,
		groupFlags = groupFlags,
		lifetime = 8.0,
		color = color,
		x = x,
		y = y,
		shape = { 0,0, 64,64, 0,64 },
	}
	return groupParams
end


-- Create image outline
local function createOutline( flags, groupFlags, color, x, y )

	local groupParams = {
		flags = flags,
		groupFlags = groupFlags,
		lifetime = 8.0,
		color = color,
		x = x,
		y = y,
		outline = image_outline,
		width = 32,
		height = 32,
	}
	return groupParams
end


-- Function to generate a new object on timer event
local function onTimer( event )

	local r
	local flags
	local groupFlags
	local x, y
	local params

	--randomize the position
	x = display.contentWidth * 0.25 * math.random( 1, 3 )
	y = -96

	--randomize the flags
	r = math.random()
	if r < ( 3.0 / 4.0 ) then
		flags = { "water", "colorMixing" }
	--elseif r < ( 5.0 / 6.0 ) then
	else
		flags = { "elastic", "colorMixing" }
	--else
		--flags = { "colorMixing" }
		--groupFlags = { "rigid" }
	end

	--randomize the color
	r = math.random()
	if r < ( 1.0 / 3.0 ) then
		color = { 1, 0, 0.1, 1 }  --red
	elseif r < ( 2.0 / 3.0 ) then
		color = { 0.2, 1, 0.1, 1 }  --green
	else
		color = { 0, 0.3, 1, 1 }  --blue
	end

	--randomize the shape
	r = math.random()
	if r < ( 1.0 / 4.0 ) then
		params = createBox( flags, groupFlags, color, x, y )
	elseif r < ( 2.0 / 4.0 ) then
		params = createCircle( flags, groupFlags, color, x, y )
	elseif r < ( 3.0 / 4.0 ) then
		params = createTriangle( flags, groupFlags, color, x, y )
	else
		params = createOutline( flags, groupFlags, color, x, y )
	end
	particleSystem:createGroup( params )
end
timer.performWithDelay( 1000, onTimer, 0 )


-- Function to queryRegion() on 'particleSystem'
local function enterFrame( event )

	if touchIsActive then

		local hits = particleSystem:queryRegion(
			box.x - ( 32/2 ),  --left limit
			box.y - ( 32/2 ),  --top limit
			box.x + ( 32/2 ),  --right limit
			box.y + ( 32/2 ),  --bottom limit
			{ velocityX=velocityX, velocityY=velocityY } )

		--if hits then debugOutput( hits ) end
	end
end
Runtime:addEventListener( "enterFrame", enterFrame )

-- Display instructions
local inst = display.newText( "touch/drag to flick particles", display.contentWidth * 0.5, 50, native.systemFont, 16 )
inst:setFillColor( 1 )
