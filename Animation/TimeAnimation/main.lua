
-- Abstract: TimeAnimation
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Time Animation", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

-- Local variables and forward references
local screenW = display.contentWidth - display.screenOriginX
local screenH = display.contentHeight - display.screenOriginY
local friction = 0.8
local gravity = 0.098
local speedX, speedY, prevX, prevY, lastTime, prevTime = 0, 0, 0, 0, 0, 0

local msg = display.newText( mainGroup, "Drag or fling the ball to bounce", 0, 0, appFont, 13 )
msg:setFillColor( 1, 0.4, 0.25 )

-- Create ball
local ball = display.newCircle( mainGroup, 0, 0, 30 )
ball:setFillColor( 0.95, 0.1, 0.3 )
ball:toBack()

-- Function to update ball on every frame
local function onMoveBall( event )

	local timePassed = event.time - lastTime
	lastTime = lastTime + timePassed

	speedY = speedY + gravity

	ball.x = ball.x + ( speedX * timePassed )
	ball.y = ball.y + ( speedY * timePassed )

	if ( ball.x >= screenW - ( ball.width * 0.5 ) ) then
		ball.x = screenW - ( ball.width * 0.5 )
		speedX = speedX * friction
		speedX = speedX * -1  -- Change direction
	elseif ( ball.x <= display.screenOriginX + ( ball.width * 0.5 ) ) then
	    ball.x = display.screenOriginX + ( ball.width * 0.5 )
		speedX = speedX * friction
		speedX = speedX * -1  -- Change direction
	end

	if ( ball.y >= screenH - ( ball.height * 0.5 ) ) then
		ball.y = screenH - ( ball.height * 0.5 )
		speedY = speedY * friction
		speedX = speedX * friction
		speedY = speedY * -1  -- Change direction
	elseif ( ball.y <= display.screenOriginY + ( ball.height * 0.5 ) ) then
		ball.y = display.screenOriginY + ( ball.height * 0.5 )
		speedY = speedY * friction
		speedY = speedY * -1  -- Change direction
	end
end

-- Function to track velocity (for fling)
local function trackVelocity( event )

	local timePassed = event.time - prevTime
	prevTime = prevTime + timePassed
	speedX = ( ball.x - prevX ) / timePassed
	speedY = ( ball.y - prevY ) / timePassed
	prevX = ball.x
	prevY = ball.y
end

-- General function for dragging objects
local function startDrag( event )

	local t = event.target
	local phase = event.phase

	if ( "began" == phase ) then

		-- Set touch focus on ball
		display.currentStage:setFocus( t )
		t.isFocus = true

		-- Store initial touch position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

		-- Stop ball's current motion, if any
		Runtime:removeEventListener( "enterFrame", onMoveBall )
		-- Start tracking velocity
		Runtime:addEventListener( "enterFrame", trackVelocity )

	elseif ( t.isFocus ) then

		if ( "moved" == phase ) then

			t.x = event.x - t.x0
			t.y = event.y - t.y0

			-- Force pseudo-touch of "ended" if ball is dragged past any screen edge
			if ( ( t.x > screenW - ( t.width * 0.5 ) ) or
				 ( t.x < display.screenOriginX + ( t.width * 0.5 ) ) or
				 ( t.y > screenH - ( t.height * 0.5 ) ) or
				 ( t.y < display.screenOriginY + ( t.height * 0.5 ) )
			) then
				t:dispatchEvent( { name="touch", phase="ended", target=t, time=event.time } )
			end

		elseif ( "ended" == phase or "cancelled" == phase ) then

			lastTime = event.time

			-- Stop tracking velocity
			Runtime:removeEventListener( "enterFrame", trackVelocity )
			-- Start ball's motion
			Runtime:addEventListener( "enterFrame", onMoveBall )

			-- Release touch focus from ball
			display.currentStage:setFocus( nil )
			t.isFocus = false
		end
	end
	return true
end

-- Resize event handler
local function onResizeEvent( event )

	screenW = display.contentWidth - display.screenOriginX
	screenH = display.contentHeight - display.screenOriginY

	msg.x = display.contentCenterX
	msg.y = 55 + display.screenOriginY

	-- Reset ball location to center of the screen
	ball.x = display.contentCenterX
	ball.y = display.contentCenterY
end

-- Set up orientation initially after the app starts
onResizeEvent()

Runtime:addEventListener( "resize", onResizeEvent )
Runtime:addEventListener( "enterFrame", onMoveBall )
ball:addEventListener( "touch", startDrag )
