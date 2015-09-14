-- 
-- Abstract: Bouncing ball (function listener) sample app (time-based animation)
--			 Drag the ball and flick it to bounce it off of the edges of the screen.
-- 
-- Version: 1.1
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Supports Graphics 2.0
---------------------------------------------------------------------------------------

local screenW, screenH = display.contentWidth, display.contentHeight
local friction = 0.8
local gravity = .09
local speedX, speedY, prevX, prevY, lastTime, prevTime = 0, 0, 0, 0, 0, 0

local background = display.newImage( "metal_bg.jpg", true )
background.x = screenW / 2
background.y = screenH / 2

local infoLabel = display.newText( "Drag or fling ball to bounce", 0, 0, native.systemFontBold, 20 )
infoLabel:setFillColor( 0, 0, 0 )
infoLabel.x = screenW / 2
infoLabel.y = 60

local ball = display.newCircle( 0, 0, 40)
ball:setFillColor( 1, 1, 1, 166/255 )
ball.x = screenW * 0.5
ball.y = ball.height

function onMoveCircle(event) 
	local timePassed = event.time - lastTime
	lastTime = lastTime + timePassed

	speedY = speedY + gravity

	ball.x = ball.x + speedX*timePassed
	ball.y = ball.y + speedY*timePassed

	if ball.x >= screenW - ball.width*.5 then
		ball.x = screenW - ball.width*.5
		speedX = speedX*friction
		speedX = speedX*-1 --change direction     
	elseif ball.x <= ball.width*.5 then
	    ball.x = ball.width*.5
		speedX = speedX*friction
		speedX = speedX*-1 --change direction     
	end
	
	if ball.y >= screenH - ball.height*.5 then
		ball.y = screenH - ball.height*.5 
		speedY = speedY*friction
		speedX = speedX*friction
		speedY = speedY*-1  --change direction  
	elseif ball.y <= ball.height*.5 then
		ball.y = ball.height*.5
		speedY = speedY*friction
		speedY = speedY*-1 --change direction     
	end
end
	
-- A general function for dragging objects
local function startDrag( event )
	local t = event.target
	local phase = event.phase

	if "began" == phase then
		display.getCurrentStage():setFocus( t )
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
						
		-- Stop current motion, if any
		Runtime:removeEventListener("enterFrame", onMoveCircle)
		-- Start tracking velocity
		Runtime:addEventListener("enterFrame", trackVelocity)

	elseif t.isFocus then
		if "moved" == phase then
					
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			lastTime = event.time		

			Runtime:removeEventListener("enterFrame", trackVelocity)
			Runtime:addEventListener("enterFrame", onMoveCircle)

			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	-- Stop further propagation of touch event!
	return true
end

function trackVelocity(event) 
	local timePassed = event.time - prevTime
	prevTime = prevTime + timePassed
	
	speedX = (ball.x - prevX)/timePassed
	speedY = (ball.y - prevY)/timePassed

	prevX = ball.x
	prevY = ball.y
end			

ball:addEventListener("touch", startDrag)
Runtime:addEventListener("enterFrame", onMoveCircle)
