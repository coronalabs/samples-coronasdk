-- Abstract: Bridge sample project
--
-- Demonstrates joints and damping
-- 
-- Version: 1.2 (revised for Alpha 3)
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

-- The final "true" parameter overrides Corona's auto-scaling of large images
local background = display.newImage( "jungle_bkg.png", centerX, centerY, true )

local pole1 = display.newImage( "bamboo.png" )
pole1.x = 50; pole1.y = 250; pole1.rotation = -12
physics.addBody( pole1, "static", { friction=0.5 } )

local pole2 = display.newImage( "bamboo.png" )
pole2.x = 430; pole2.y = 250; pole2.rotation = 12
physics.addBody( pole2, "static", { friction=0.5 } )

local instructionLabel = display.newText( "touch boards to break bridge, touch rocks to remove", centerX, 40, native.systemFont, 17 )
instructionLabel:setFillColor( 190/255, 1, 131/255, 150/255 )

local board = {}
local joint = {}

-- A touch listener to "break" bridge joints
local breakJoint = function( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		local myIndex = t.myIndex
		if ( joint[myIndex] ) then
			print( "breaking joint at board#" .. myIndex )
			joint[myIndex]:removeSelf()
			joint[myIndex] = nil
		elseif ( joint[myIndex+1] ) then
			myIndex = myIndex + 1
			print( "breaking joint at board#" .. myIndex )
			joint[myIndex]:removeSelf()
			joint[myIndex] = nil
		end
	end

	-- Stop further propagation of touch event
	return true
end

-- A touch listener to remove rocks
local removeBody = function( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		t:removeSelf() -- destroy object
		t = nil
	end

	-- Stop further propagation of touch event
	return true
end


for j = 1,16 do
	board[j] = display.newImage( "board.png" )
	board[j].x = 20 + (j*26)
	board[j].y = 150
	board[j].myIndex = j -- for touch handler above
	board[j]:addEventListener( "touch", breakJoint ) -- assign touch listener to board
	
	physics.addBody( board[j], { density=2, friction=0.3, bounce=0.3 } )
	
	-- damping the board motion increases the "tension" in the bridge
	board[j].angularDamping = 5000
	board[j].linearDamping = 0.7

	-- create joints between boards
	if (j > 1) then
		prevLink = board[j-1] -- each board is joined with the one before it
	else
		prevLink = pole1 -- first board is joined to left pole
	end
	joint[j] = physics.newJoint( "pivot", prevLink, board[j], 6+(j*26), 150 )

end

-- join final board to right pole
joint[#joint + 1] = physics.newJoint( "pivot", board[16], pole2, 6+(17*26), 150 )

local balls = {}

-- function to drop random coconuts and rocks
local randomBall = function()

	choice = math.random( 100 )
	local ball
	
	if ( choice < 80 ) then
		ball = display.newImage( "coconut.png" )
		ball.x = 40 + math.random( 380 ); ball.y = -40
		physics.addBody( ball, { density=0.6, friction=0.6, bounce=0.6, radius=19 } )
		ball.angularVelocity = math.random(800) - 400
		ball.isSleepingAllowed = false
	
	else
		ball = display.newImage( "rock.png" )
		ball.x = 40 + math.random( 380 ); ball.y = -40
		physics.addBody( ball, { density=2.0, friction=0.6, bounce=0.2, radius=33 } )
		ball.angularVelocity = math.random(600) - 300
	
	end
	
	ball:addEventListener( "touch", removeBody ) -- assign touch listener to rock
	balls[#balls + 1] = ball	
end

-- run the above function 14 times
timer.performWithDelay( 1500, randomBall, 14 )