-- 
-- Abstract: CollisionDetection sample project
-- Demonstrates global and local collision listeners, along with collision forces
-- 
-- Version: 1.2 (revised for Alpha 3, demonstrates "collision" event and new "preCollision" and "postCollision" events)
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

local physics = require( "physics" )
physics.start()

local sky = display.newImage( "bkg_clouds.png", centerX, 195 )

local ground = display.newImage( "ground.png", centerX, 445 )
ground.myName = "ground"

-- The parameter "myName" is arbitrary; you can add any parameters, functions or data to Corona display objects

physics.addBody( ground, "static", { friction=0.5, bounce=0.3 } )

local crate1 = display.newImage( "crate.png", 180, -50 )
crate1.myName = "first crate"

local crate2 = display.newImage( "crate.png", 180, -150 )
crate2.myName = "second crate"

physics.addBody( crate1, { density=3.0, friction=0.5, bounce=0.3 } )
physics.addBody( crate2, { density=3.0, friction=0.5, bounce=0.3 } )

-- Uncomment this to obtain collision positions in content coordinates.
--physics.setReportCollisionsInContentCoordinates( true )

-- Uncomment this to obtain an average of all collision positions.
--physics.setAverageCollisionPositions( true )

----------------------------------------------------------
-- Two collision types (run Corona Terminal to see output)
----------------------------------------------------------


-- METHOD 1: Use table listeners to make a single object report collisions between "self" and "other"

local function onLocalCollision( self, event )
	if ( event.phase == "began" ) then

		print( self.myName .. ": collision began with " .. event.other.myName )

	elseif ( event.phase == "ended" ) then

		print( self.myName .. ": collision ended with " .. event.other.myName )

	end
end

crate1.collision = onLocalCollision
crate1:addEventListener( "collision" )

crate2.collision = onLocalCollision
crate2:addEventListener( "collision" )


-- METHOD 2: Use a runtime listener to globally report collisions between "object1" and "object2"
-- Note that the order of object1 and object2 may be reported arbitrarily in any collision

local function onGlobalCollision( event )
	if ( event.phase == "began" ) then

		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision began" )

	elseif ( event.phase == "ended" ) then

		print( "Global report: " .. event.object1.myName .. " & " .. event.object2.myName .. " collision ended" )

	end
	
	print( "**** " .. event.element1 .. " -- " .. event.element2 )
	
end

Runtime:addEventListener( "collision", onGlobalCollision )


-------------------------------------------------------------------------------------------
-- New pre- and post-collision events (run Corona Terminal to see output)
--
-- preCollision can be quite "noisy", so you probably want to make its listeners
-- local to the specific objects you care about, rather than a global Runtime listener
-------------------------------------------------------------------------------------------

local function onLocalPreCollision( self, event )
	-- This new event type fires shortly before a collision occurs, so you can use this if you want
	-- to override some collisions in your game logic. For example, you might have a platform game
	-- where the character should jump "through" a platform on the way up, but land on the platform
	-- as they fall down again.
	
	-- Note that this event is very "noisy", since it fires whenever any objects are somewhat close!

	print( "preCollision: " .. self.myName .. " is about to collide with " .. event.other.myName )

end

local function onLocalPostCollision( self, event )
	-- This new event type fires only after a collision has been completely resolved. You can use 
	-- this to obtain the calculated forces from the collision. For example, you might want to 
	-- destroy objects on collision, but only if the collision force is greater than some amount.
	
	if ( event.force > 5.0 ) then
		print( "postCollision force: " .. event.force .. ", friction: " .. event.friction )
	end

end

-- Here we assign the above two functions to local listeners within crate1 only, using table listeners:

crate1.preCollision = onLocalPreCollision
crate1:addEventListener( "preCollision", crate1 )

crate1.postCollision = onLocalPostCollision
crate1:addEventListener( "postCollision", crate1 )
