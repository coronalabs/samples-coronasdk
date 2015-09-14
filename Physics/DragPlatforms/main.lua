-- 
-- Abstract: DragPlatforms sample project
-- Demonstrates one method for draggable physics objects
-- 
-- Version: 1.2 (changed two graphics -- 5/13/11)
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

display.setStatusBar( display.HiddenStatusBar )

-- A basic function for dragging physics objects
local function startDrag( event )
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
		
		-- Make body type temporarily "kinematic" (to avoid gravitional forces)
		event.target.bodyType = "kinematic"
		
		-- Stop current motion, if any
		event.target:setLinearVelocity( 0, 0 )
		event.target.angularVelocity = 0

	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			
			-- Switch body type back to "dynamic", unless we've marked this sprite as a platform
			if ( not event.target.isPlatform ) then
				event.target.bodyType = "dynamic"
			end

		end
	end

	-- Stop further propagation of touch event!
	return true
end

local background = display.newImage( "bkg_bricks.png", centerX, centerY, true )

local ground = display.newImage( "floor.png", 160, 440 )
physics.addBody( ground, "static", { friction=0.6 } )

local platform1 = display.newImage( "platform1.png", 80, 200 )
physics.addBody( platform1, "kinematic", { friction=0.7 } )
platform1.isPlatform = true -- custom flag, used in drag function above

local cube = display.newImage( "house_red.png", 80, 150 ) -- I'm making a note here: huge success
physics.addBody( cube, { density=5.0, friction=0.3, bounce=0.4 } )

local crate = display.newImage( "crate.png", 90, 90 )
physics.addBody( crate, { density=3.0, friction=0.4, bounce=0.2 } )

local platform2 = display.newImage( "platform2.png", 240, 150 )
physics.addBody( platform2, "kinematic", { friction=0.7 } )
platform2.isPlatform = true -- custom flag again

local block = display.newImage( "books_red.png", 240, 125 )
physics.addBody( block, { density=1.0, bounce=0.4 } )
block.isFixedRotation = true -- books blocks don't rotate, they just fall straight down

-- Add touch event listeners to objects
platform1:addEventListener( "touch", startDrag )
platform2:addEventListener( "touch", startDrag )
cube:addEventListener( "touch", startDrag )
crate:addEventListener( "touch", startDrag )
block:addEventListener( "touch", startDrag )