-- 
-- Abstract: Alert sample app
-- 
-- Version: 1.1
-- 
-- Update History:
--	1.0		January 25, 2010		Initial version
--	1.1		November 16, 2016		Added native.canOpenURL() checks before trying to show the popups
--
-- Copyright (C) 2009-2016 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.
--
-- Supports Graphics 2.0

-- Handler that gets notified when the alert closes
local function onComplete( event )
	print( "index => ".. event.index .. "    action => " .. event.action )

	local action = event.action
	if "clicked" == event.action then
		if 2 == event.index then
			-- Open url if "Learn More" was clicked by the user
			local urlToOpen = "https://www.coronalabs.com"
			if system.canOpenURL( urlToOpen ) then
				system.openURL( urlToOpen )
			else
				print( "Cannot access coronalabs.com" )
				native.showAlert( "Alert", "No browser found to open coronalabs.com", { "OK" } )
			end
		end
	elseif "cancelled" == event.action then
		-- our cancelAlert timer function dismissed the alert so do nothing
	end
end

-- Show alert
local alert = native.showAlert( "Corona", "Dream. Build. Ship.", { "OK", "Learn More" }, onComplete )

-- Dismisses alert after 10 seconds
local function cancelAlert()
	native.cancelAlert( alert )
end

timer.performWithDelay( 10000, cancelAlert )


--------------------------------------------------------------------------------
-- Below is a simplified version of the Fishies sample code.
-- It's here just to show you that animation continues 
-- when the native alert is displayed.
--------------------------------------------------------------------------------


-- Seed randomizer
local seed = os.time();
math.randomseed( seed )

-- Background
local halfW = display.contentWidth / 2
local halfH = display.contentHeight / 2

local backgroundPortrait = display.newImage( "aquariumbackgroundIPhone.jpg", halfW, halfH )

-- Fishies
local numFish = 10
local file1 = "fish.small.red.png"
local file2 = "fish.small.blue.png"

-- Define touch listener for fish so that fish can behave like buttons.
-- The listener will receive an 'event' argument containing a "target" property
-- corresponding to the object that was the target of the interaction.
-- This eliminates closure overhead (i.e. the need to reference non-local variables )
local buttonListener = function( event )
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


-- Create a table to store all the fish and register this table as the 
-- "enterFrame" listener to animate all the fish.
local bounceAnimation = {
	container = display.getCurrentStage(),
	reflectX = true,
}

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
	group.vx = math.random( 1, 5 )
	group.vy = math.random( -2, 2 )

	-- add fish to animation group so that it will bounce
	bounceAnimation[ #bounceAnimation + 1 ] = group
end

-- Function to animate all the fish
function bounceAnimation:enterFrame( event )
	local container = self.container
	local containerBounds = container.contentBounds
	local xMin = containerBounds.xMin
	local xMax = containerBounds.xMax
	local yMin = containerBounds.yMin
	local yMax = containerBounds.yMax

	local reflectX = nil ~= self.reflectX
	local reflectY = nil ~= self.reflectY

	-- the fish groups are stored in integer arrays, so iterate through all the 
	-- integer arrays
	for i,v in ipairs( self ) do
		local object = v  -- the display object to animate, e.g. the fish group
		local vx = object.vx
		local vy = object.vy

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
