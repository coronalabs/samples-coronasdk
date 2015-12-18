-- 
-- Abstract: ShapeTumbler sample project
-- Demonstrates polygon body constructor and tilt-based gravity effects (on device only)
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see https://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
--	Supports Graphics 2.0
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

math.randomseed( system.getTimer() )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Shape Tumbler", showBuildNum=true } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local tumblingGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local physics = require("physics")
physics.start()

physics.setScale( 60 )
physics.setGravity( 0, 9.8 ) -- initial gravity points downwards
--physics.setDrawMode( "hybrid" )

-- Create physical borders
local borderThickeness = 30
borderBodyElement = { friction=0.5, bounce=0.3 }

local borderTop = display.newRect( display.contentCenterX, 0 + borderThickeness/2, display.contentWidth, borderThickeness )
borderTop:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderTop, "static", borderBodyElement )

local borderBottom = display.newRect( display.contentCenterX, display.contentHeight + borderThickeness/2, display.contentWidth, borderThickeness )
borderBottom:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderBottom, "static", borderBodyElement )

local borderLeft = display.newRect( 0 - borderThickeness/2, display.contentCenterY, 0 - borderThickeness, display.contentHeight )
borderLeft:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderLeft, "static", borderBodyElement )

local borderRight = display.newRect( display.contentWidth + borderThickeness/2, display.contentCenterY, borderThickeness, display.contentHeight )
borderRight:setFillColor( 0, 0, 0, 0)		-- make invisible
physics.addBody( borderRight, "static", borderBodyElement )


-- Create objects
local spawnMinX = borderThickeness/2 + 25
local spawnMaxX = borderThickeness/-2 - 25 + display.contentWidth
local spawnMinY = borderThickeness/2 + 25
local spawnMaxY = borderThickeness/-2 - 25 + display.contentHeight

-- Create a triangle object.
local triangleShape = { 0,-35, 37,30, -37,30 }
local function createTriangle()
	local triangle = display.newImage( tumblingGroup, "triangle.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( triangle, { density=0.9, friction=0.5, bounce=0.3, shape=triangleShape } )
	return triangle
end

-- Create pentagon object.
local pentagonShape = { 0,-37, 37,-10, 23,34, -23,34, -37,-10 }
local function createPentagon()
	local pentagon = display.newImage( tumblingGroup, "pentagon.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( pentagon, { density=0.9, friction=0.5, bounce=0.4, shape=pentagonShape } )
	return pentagon
end

-- Create box
local function createBox()
	local box = display.newImage( tumblingGroup, "box.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( box, { density=2, friction=0.5, bounce=0.4 } )
	return box
end

-- Create crate
local function createCrate()
	local crate = display.newImage( tumblingGroup, "crate.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( crate, { density=4, friction=0.5, bounce=0.4 } )
	return crate
end

-- Create cell
local function createCell()
	local cell = display.newImage( tumblingGroup, "cell.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( cell, { density=1, friction=0.5, bounce=0.4 } )
	return cell
end

-- Create superball
local function createSuperball()
	local superball = display.newImage( tumblingGroup, "super_ball.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( superball, { density=0.9, friction=0.5, bounce=0.8, radius=24 } )
	return superball
end

-- Create soccerball
local function createSoccerball()
	local soccerball = display.newImage( tumblingGroup, "soccer_ball.png", math.random( spawnMinX, spawnMaxX ), math.random( spawnMinY, spawnMaxY ) )
	physics.addBody( soccerball, { density=0.9, friction=0.5, bounce=0.6, radius=38 } )
	return soccerball
end

-- Create a random shape for the canvas.
local shapeTypes = 7
local function createRandomObject()
	local r = math.random( 1, shapeTypes )
	local object = nil

	if ( r == 1 ) then
		object = createTriangle()
	elseif ( r == 2 ) then
		object = createPentagon()
	elseif ( r == 3 ) then
		object = createBox()
	elseif ( r == 4 ) then
		object = createCrate()
	elseif ( r == 5 ) then
		object = createCell()
	elseif ( r == 6 ) then
		object = createSuperball()
	elseif ( r == 7 ) then
		object = createSoccerball()
	end

	-- Prevent physics objects from sleeping.
	object.isSleepingAllowed = false

	return object
end

-- Fill the canvas with some objects! We'll create one object per 20,000 square content units.
local objectsToCreate = math.floor( display.contentWidth * display.contentHeight / 20000 )
for i = 1, objectsToCreate do
	createRandomObject()
end

-- Set accelerometer to maximum responsiveness
system.setAccelerometerInterval( 100 )

-- Build this demo for Android, iOS, or tvOS to see accelerometer-based gravity
function onTilt( event )
	-- Gravity is in portrait orientation on Android/iOS/Windows Phone.
	-- On tvOS, gravity is in the orientation of the device attached to the event.
	if ( event.device ) then
		physics.setGravity( ( 9.8 * event.xGravity ), ( -9.8 * event.yGravity ) )
	else
		physics.setGravity( ( -9.8 * event.yGravity ), ( -9.8 * event.xGravity ) )
	end
end

Runtime:addEventListener( "accelerometer", onTilt )
