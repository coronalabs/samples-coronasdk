-- 
-- Abstract: Bouncing ball (function listener) sample app (time-based animation)
--			 Drag the ball and flick it to bounce it off of the edges of the screen.
--
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010-2015 Corona Labs Inc. All Rights Reserved.
--
-- History
--	12/15/2015		Modified for landscape/portrait modes for tvOS
---------------------------------------------------------------------------------------

local screenW, screenH = display.contentWidth, display.contentHeight
local friction = 0.8
local gravity = .09
local speedX, speedY, prevX, prevY, lastTime, prevTime = 0, 0, 0, 0, 0, 0

local background = display.newImage( "metal_bg.jpg", true )

local infoLabel = display.newText( "Drag or fling ball to bounce", 0, 0, native.systemFontBold, 20 )
infoLabel.y = 60

if "tvOS" == system.getInfo( "platformName" ) then
	warningText = display.newText( "(Not supported on Apple TV)", 0, 0, native.systemFontBold, 20 )
	warningText.y = 85
end

local ball = display.newCircle( 0, 0, 40)
ball:setFillColor( 1, 1, 1, 166/255 )

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

-----------------------------------------------------------------------
-- Change the orientation of the app here
--
-- Adjust objects for Portrait or Landscape mode
--
-- Enter: mode = orientation mode
-----------------------------------------------------------------------
--
function changeOrientation( mode ) 
	print( "changeOrientation ...", mode )

	screenW, screenH = display.contentWidth, display.contentHeight
	background.x = screenW / 2
	background.y = screenH / 2
	infoLabel.x = screenW / 2
	ball.x = screenW * 0.5
	ball.y = ball.height

	if warningText then
		warningText.x = screenW / 2
	end

	if string.find( mode, "portrait") then 
		background.rotation = 0
	elseif string.find( mode, "landscape") then
		background.rotation = 90
	end
end

-----------------------------------------------------------------------
-- Come here on Resize Events
-- Display the Orientation Message on the screen
-----------------------------------------------------------------------
--
function onResizeEvent( event ) 
	print ("onResizeEvent: " .. event.name)
	changeOrientation( system.orientation )
end

-- Set up the display after the app starts
changeOrientation( system.orientation )

-- Add the Orientation callback event
Runtime:addEventListener( "resize", onResizeEvent )

ball:addEventListener("touch", startDrag)
Runtime:addEventListener("enterFrame", onMoveCircle)
