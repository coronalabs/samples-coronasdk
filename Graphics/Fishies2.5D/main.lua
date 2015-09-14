--
-- Abstract: Fishies 2.5D sample app
--
-- Date: September 10, 2010
--
-- Version: 1.0
--
-- File name: main.lua
--
-- Author: Corona Labs
--
-- Demonstrates: graphics, orientation, object touch
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

--display.setDrawMode( "wireframe")

--local bkgd = display.newImage( "Default2.png", 0, 0 )

local halfW = display.contentWidth * 0.5
local halfH = display.contentHeight * 0.5

local x = display.contentCenterX
local y = display.contentCenterY

local bkgd = display.newImage( "aquariumbackgroundIPhone.jpg", x, y )

local a = display.newImage( "A.png", x, y )
local b = display.newImage( "B.png", x, y )

transition.to( a.path, { x1=halfW, x3=-halfW, y3=-100, 
					x2=halfW, x4=-halfW, y4=100,
					time=1500, delay=1000, transition=easing.inExpo } )
transition.from( b.path, { x1=halfW, y1= 100, x3=-halfW,
					  x2=halfW, y2=-100, x4=-halfW,
					  time=1500, delay=2500, transition=easing.outExpo } )
--]]

-------------------------------------------------------------------------------
---[[
-- Seed randomizer
local seed = os.time();
math.randomseed( seed )

display.setStatusBar( display.HiddenStatusBar )

-- Preload the sound file (theoretically, we should also dispose of it when we are completely done with it)
local soundID = audio.loadSound( "bubble_strong_wav.wav" ) 

-- Background
local halfW = display.viewableContentWidth / 2
local halfH = display.viewableContentHeight / 2

-- Create a table to store all the fish and register this table as the 
-- "enterFrame" listener to animate all the fish.
local bounceAnimation = {
	container = display.newRect( x, y, display.viewableContentWidth, display.viewableContentHeight ),
	reflectX = true,
}

bounceAnimation.container.isVisible = false

-- 
-- Fishies
local numFish = 10
local file1 = "fish.small.red.png"
local file2 = "fish.small.blue.png"      
-- 
-- Define touch listener for fish so that fish can behave like buttons.
-- The listener will receive an 'event' argument containing a "target" property
-- corresponding to the object that was the target of the interaction.
-- This eliminates closure overhead (i.e. the need to reference non-local variables )
local buttonListener = function( event )
	if "ended" == event.phase then
		local group = event.target

		-- tap only triggers change from original to different color
		local topObject = group[1]

		if ( topObject.isVisible ) then
			local bottomObject = group[2]

			-- Dissolve to bottomObject (different color)
			transition.dissolve( topObject, bottomObject, 500 )

			-- Restore after some random delay
			transition.dissolve( bottomObject, topObject, 500, math.random( 3000, 10000 ) )
		end

		-- we handled it so return true to stop propagation
		return true
	end
end                                        
-- 
-- 


-- 
-- Add fish to the screen
for i=1,numFish do
	-- create group which will represent our fish, storing both images (file1 and file2)
	local group = display.newGroup()

	local fishOriginal = display.newImage( file1 )
	group:insert( fishOriginal, true )  -- accessed in buttonListener as group[1]

	local fishDifferent = display.newImage( file2 )
	group:insert( fishDifferent, true ) -- accessed in buttonListener as group[2]
	fishDifferent.isVisible = false -- make file2 invisible

	-- move to random position in a 200x200 region in the middle of the screen
	group:translate( halfW + math.random( -100, 100 ), halfH + math.random( -100, 100 ) )

	-- connect buttonListener. touching the fish will cause it to change to file2's image
	group:addEventListener( "touch", buttonListener )

	-- assign each fish a random velocity
	group.vx = math.random( 2, 5 )
	group.vy = math.random( -2, 2 )

	-- add fish to animation group so that it will bounce
	bounceAnimation[ #bounceAnimation + 1 ] = group
end                                                       
-- 
-- Function to animate all the fish
function bounceAnimation:enterFrame( event )
	local container = self.container
	container:setFillColor( 0, 0, 0, 0)		-- make invisible
	local containerBounds = container.contentBounds
	local xMin = containerBounds.xMin
	local xMax = containerBounds.xMax
	local yMin = containerBounds.yMin
	local yMax = containerBounds.yMax

	local orientation = self.currentOrientation
	local isLandscape = "landscapeLeft" == orientation or "landscapeRight" == orientation

	local reflectX = nil ~= self.reflectX
	local reflectY = nil ~= self.reflectY

	-- the fish groups are stored in integer arrays, so iterate through all the 
	-- integer arrays
	for i,v in ipairs( self ) do
		local object = v  -- the display object to animate, e.g. the fish group
		local vx = object.vx
		local vy = object.vy

		if ( isLandscape ) then
			if ( "landscapeLeft" == orientation ) then
				local vxOld = vx
				vx = -vy
				vy = -vxOld
			elseif ( "landscapeRight" == orientation ) then
				local vxOld = vx
				vx = vy
				vy = vxOld
			end
		elseif ( "portraitUpsideDown" == orientation ) then
			vx = -vx
			vy = -vy
		end

		-- TODO: for now, time is measured in frames instead of seconds...
		local dx = vx
		local dy = vy

		local bounds = object.contentBounds

		local flipX = false
		local flipY = false

		if (bounds.xMax + dx) > xMax then
			flipX = true
			dx = xMax - bounds.xMax
		elseif (bounds.xMin + dx) < xMin then
			flipX = true
			dx = xMin - bounds.xMin
		end

		if (bounds.yMax + dy) > yMax then
			flipY = true
			dy = yMax - bounds.yMax
		elseif (bounds.yMin + dy) < yMin then
			flipY = true
			dy = yMin - bounds.yMin
		end

		if ( isLandscape ) then flipX,flipY = flipY,flipX end
		if ( flipX ) then
			object.vx = -object.vx
			if ( reflectX ) then object:scale( -1, 1 ) end
		end
		if ( flipY ) then
			object.vy = -object.vy
			if ( reflectY ) then object:scale( 1, -1 ) end
		end

		object:translate( dx, dy )
	end
end

Runtime:addEventListener( "enterFrame", bounceAnimation );

-- This function is never called, 
-- but shows how we would unload the sound if we wanted to
function unloadSound()
	audio.dispose(soundID)
	soundID = nil
end

--]]