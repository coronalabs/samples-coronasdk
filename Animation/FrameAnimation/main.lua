
-- Abstract: FrameAnimation
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Frame Animation", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Local variables and forward references
local screenTop 
local screenBottom 
local screenLeft
local screenRight

-- Array for balls to animate (parameters)
local params = {
	{ radius=18, xDir=1, yDir=1, xSpeed=2.5, ySpeed=6.0, r=1, g=0, b=0.1 },
	{ radius=15, xDir=1, yDir=1, xSpeed=3.5, ySpeed=4.0, r=0.95, g=0.1, b=0.3 },
	{ radius=22, xDir=1, yDir=-1, xSpeed=5.5, ySpeed=5.0, r=0.9, g=0.2, b=0.5 }
}

local ballCollection = {}

-- Iterate through params array and add new balls into "ballCollection" array
for item = 1,#params do
	local itemParams = params[item]
	local ball = display.newCircle( mainGroup, display.contentCenterX, display.contentCenterY, itemParams.radius )
	ball:setFillColor( itemParams.r, itemParams.g, itemParams.b )
	ball.xDir = itemParams.xDir
	ball.yDir = itemParams.yDir
	ball.xSpeed = itemParams.xSpeed
	ball.ySpeed = itemParams.ySpeed
	ball.radius = itemParams.radius
	ballCollection[#ballCollection+1] = ball
end

-- Function to update balls on every frame
local function moveBalls( event )

	for i = 1,#ballCollection do

		local ball = ballCollection[i]
		-- Calculate next delta position
		local dx = ( ball.xSpeed * ball.xDir )
		local dy = ( ball.ySpeed * ball.yDir )

		-- If ball has touched any screen edge, reverse direction
		local xNew, yNew = ball.x + dx, ball.y + dy
		local radius = ball.radius
		if ( xNew > screenRight - radius or xNew < screenLeft + radius ) then
			ball.xDir = -ball.xDir
		end
		if ( yNew > screenBottom - radius or yNew < screenTop + radius ) then
			ball.yDir = -ball.yDir
		end

		-- Move ball to next delta position
		ball:translate( dx, dy )
	end
end

-- Resize event handler
local function onResizeEvent( event )

	-- Get current edges of visible screen, accounting for letterbox areas
	screenTop = display.screenOriginY
	screenBottom = display.contentHeight - display.screenOriginY
	screenLeft = display.screenOriginX
	screenRight = display.contentWidth - display.screenOriginX

	-- Iterate through the ball array and reset the location to center of the screen
	for i = 1,#ballCollection  do
		ballCollection[i].x = display.contentCenterX
		ballCollection[i].y = display.contentCenterY
	end
end

-- Set up orientation initially after the app starts
onResizeEvent()

Runtime:addEventListener( "resize", onResizeEvent )
Runtime:addEventListener( "enterFrame", moveBalls )
