
-- Abstract: Shape Tumbler
-- Version: 1.1
-- Sample code is MIT licensed; see https://solar2d.com/LICENSE.txt
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
math.randomseed( os.time() )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Shape Tumbler", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local worldGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set up physics engine
local physics = require( "physics" )
physics.start( true )  -- Pass "true" as first parameter to prevent bodies from sleeping
physics.setGravity( 0, 9.8 )  -- Initial gravity points downwards
physics.setScale( 60 )

-- Declare initial variables
local letterboxWidth = math.abs(display.screenOriginX)
local letterboxHeight = math.abs(display.screenOriginY)

-- Create "walls" around screen
local wallL = display.newRect( worldGroup, 0-letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallL.anchorX = 1
physics.addBody( wallL, "static", { bounce=1, friction=0.1 } )

local wallR = display.newRect( worldGroup, 480+letterboxWidth, display.contentCenterY, 20, display.actualContentHeight )
wallR.anchorX = 0
physics.addBody( wallR, "static", { bounce=1, friction=0.1 } )

local wallT = display.newRect( worldGroup, display.contentCenterX, 0-letterboxHeight, display.actualContentWidth, 20 )
wallT.anchorY = 1
physics.addBody( wallT, "static", { bounce=0, friction=0 } )

local wallB = display.newRect( worldGroup, display.contentCenterX, 320+letterboxHeight, display.actualContentWidth, 20 )
wallB.anchorY = 0
physics.addBody( wallB, "static", { bounce=0.4, friction=0.6 } )

-- Create triangle function
local function createTriangle()
	local triangleShape = { 0,-32, 37,32, -37,32 }
	local triangle = display.newPolygon( worldGroup, 0, 0, triangleShape )
	physics.addBody( triangle, { friction=0.5, bounce=0.3, shape=triangleShape } )
	return triangle
end

-- Create hexagon function
local function createHexagon()
	local hexagonShape = { 0,-38, 33,-19, 33,19, 0,38, -33,19, -33,-19 }
	local hexagon = display.newPolygon( worldGroup, 0, 0, hexagonShape )
	physics.addBody( hexagon, { friction=0.5, bounce=0.4, shape=hexagonShape } )
	return hexagon
end

-- Create small box function
local function createBoxSmall()
	local boxSmall = display.newRect( worldGroup, 0, 0, 50, 50 )
	physics.addBody( boxSmall, { friction=0.5, bounce=0.4 } )
	return boxSmall
end

-- Create large box function
local function createBoxLarge()
	local boxLarge = display.newRect( worldGroup, 0, 0, 75, 75 )
	physics.addBody( boxLarge, { friction=0.5, bounce=0.4 } )
	return boxLarge
end

-- Create cell function
local function createCell()
	local cellShape = { -30,-10, -25,-15, 25,-15, 30,-10, 30,10, 25,15, -25,15, -30,10 }
	local cell = display.newPolygon( worldGroup, 0, 0, cellShape )
	physics.addBody( cell, { friction=0.5, bounce=0.4, shape=cellShape } )
	return cell
end

-- Create ball function
local function createBall()
	local ball = display.newCircle( worldGroup, 0, 0, 30 )
	physics.addBody( ball, { friction=0.5, bounce=0.7, radius=30 } )
	return ball
end

-- Create random object function
local function createRandomObject()
	local r = math.random( 1, 6 )
	local object

	if ( r == 1 ) then
		object = createTriangle()
	elseif ( r == 2 ) then
		object = createHexagon()
	elseif ( r == 3 ) then
		object = createBoxSmall()
	elseif ( r == 4 ) then
		object = createBoxLarge()
	elseif ( r == 5 ) then
		object = createCell()
	elseif ( r == 6 ) then
		object = createBall()
	end

	return object
end

-- Fill the content area with some objects
local function spawnObjects()
	local xIndex = 0
	local yPos = 100

	for i = 1, 8 do
		local object = createRandomObject()
		object:setFillColor( ( math.random( 4, 8 ) / 10 ), ( math.random( 0, 2 ) / 10 ), ( math.random( 4, 10 ) / 10 ) )

		if ( xIndex == 4 ) then
			xIndex = 0
			yPos = 220
		end

		object.y = yPos + ( math.random( -1, 1 ) * 15 )
		object.x = ( xIndex * 120 ) + 60 + ( math.random( -1, 1 ) * 15 )
		xIndex = xIndex + 1
	end
end

-- Function to adjust gravity based on accelerometer response
local function onTilt( event )
	-- Gravity is in portrait orientation on Android, iOS, and Windows Phone
	-- On tvOS, gravity is in the orientation of the device attached to the event
	if ( event.device ) then
		physics.setGravity( ( 9.8 * event.xGravity ), ( -9.8 * event.yGravity ) )
	else
		physics.setGravity( ( -9.8 * event.yGravity ), ( -9.8 * event.xGravity ) )
	end
end

-- Detect if accelerometer is supported
if ( system.hasEventSource( "accelerometer" ) ) then
	-- Set accelerometer to maximum responsiveness
	system.setAccelerometerInterval( 100 )
	-- Start listening for accelerometer events
	Runtime:addEventListener( "accelerometer", onTilt )
	-- Spawn some objects
	spawnObjects()
else
	local shade = display.newRect( worldGroup, display.contentCenterX, display.contentHeight-display.screenOriginY-18, display.actualContentWidth, 36 )
	shade:setFillColor( 0, 0, 0, 0.7 )
	local msg = display.newText( worldGroup, "Accelerometer not supported on this platform", display.contentCenterX, shade.y, appFont, 13 )
	msg:setFillColor( 1, 0, 0.2 )
end
